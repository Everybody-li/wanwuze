-- ##Title web-查询品类信息分页列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类信息分页列表
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（模糊搜索,查询所有传空）
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output guid char[36] 品类guid;
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output img string[50] 品类图片地址;品类图片地址
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output delBtnFlag int[>=0] 1;品类删除按钮高亮标志（0：置灰，1：高亮）

# 固化的物流服务不可以删除
select t.guid         as categoryGuid
     , t.name         as categoryName
     , t.img
     , t.cattype_name as cattypeName
     , case
           when guid = '528a9e65-9d66-4e2d-a078-84a52096bb4b' then 0
           else 1 end as delBtnFlag
from coz_category_info t
where (t.name like '%{categoryName}%' or '{categoryName}' = '')
  and t.del_flag = '0'
order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};


