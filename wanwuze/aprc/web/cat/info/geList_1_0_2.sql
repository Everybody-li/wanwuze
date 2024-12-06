-- ##Title web-查询品类信息分页列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类信息分页列表
-- ##Describe coz_category_supplydemand t2,coz_category_scene_tree t3,coz_cattype_sd_path t4
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;路径guid
-- ##input categoryName string[50] NULL;品类名称（模糊搜索,查询所有传空）
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output guid char[36] 品类guid;
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output delBtnFlag int[>=0] 1;品类删除按钮高亮标志（0：置灰，1：高亮）
-- ##output catMode enum[1,2,3] ;品类模式:1-沟通模式,2-交易模式,3-审批模式


select t1.guid         as categoryGuid
     , t1.name         as categoryName
     , t1.cattype_name as cattypeName
     , t1.mode as catMode
     , case
           when (exists(select 1 from coz_category_supplydemand where category_guid = t1.guid and del_flag = '0'))
               then 1
           else 0 end  as delBtnFlag
from coz_category_info t1
         inner join
     coz_category_supplydemand t2
     on t1.guid = t2.category_guid
         inner join
     coz_category_scene_tree t3
     on t2.scene_tree_guid = t3.guid
where (t1.name like '%{categoryName}%' or '{categoryName}' = '')
  and t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.sd_path_guid = '{sdPathGuid}'
group by t1.guid
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};
