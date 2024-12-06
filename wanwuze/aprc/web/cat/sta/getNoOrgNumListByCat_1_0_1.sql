-- ##Title web-交易条件管理-查询交易组织跟踪管理-无供应机构_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易条件管理-查询交易组织跟踪管理-无供应机构_1_0_1
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;机构名称(模糊搜索)
-- ##input curUserId string[36] NOTNULL;登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>=0] NOTNULL;第几页（默认1）

select
    t1.guid         as categoryGuid
  , t1.name         as categoryName
  , t1.cattype_name as cattypeName
from
    coz_category_info             t1
    left join
        coz_category_supplier     t2
            on t2.category_guid = t1.guid and t2.del_flag = '0'
    inner join
        coz_category_supplydemand t3
            on t1.guid = t3.category_guid
    inner join
        coz_category_scene_tree   t4
            on t3.scene_tree_guid = t4.guid
where
      t1.del_flag = '0'
  and t3.del_flag = '0'
  and t4.del_flag = '0' {dynamic:cattypeGuid[ and t1.cattype_guid = '{cattypeGuid}']/dynamic} -- 非必填入参,不列出来,两处共用,前端传参不一致
{dynamic:sdPathGuid[ and t4.sd_path_guid = '{sdPathGuid}' ]/dynamic} -- 非必填入参,不列出来,两处共用,前端传参不一致
{dynamic:categoryName[ and t1.name like '%{categoryName}%' ]/dynamic}
and t2.guid is null
order by t1.id
desc
Limit {compute:[({page}-1)*{size}]/compute},{size};