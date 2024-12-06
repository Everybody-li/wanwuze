-- ##Title web-对接专员操作管理-供方对接管理-采购供应跟踪管理-审批/交易模式-各状态下-查询供应供方信息
-- ##Author 卢文彪
-- ##CreateTime 2023-11-23
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic,coz_org_info,coz_cattype_sd_path,coz_lgcode_fixed_data
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;业务guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output orgID char[18] ;供应供方-机构账号ID
-- ##output orgCreateTime char[19] 2023-12-12 12:12:12;供应供方-账号开通日期
-- ##output orgLoginSysName string[50] ;供应供方-登录系统
-- ##output orgName string[50] ;供应供方-机构名称
-- ##output orgPhone string[20] ;供应供方-登录手机号

select *
from (select coi.org_ID                       as orgID
           , left(coi.create_time, 19)        as orgCreateTime
           , left(lfd.login_sysname, 19)      as orgLoginSysName
           , coi.name                         as orgName
           , concat('(+86)', coi.phonenumber) as orgPhone
      from coz_server3_cate_dealstatus_statistic t1
               left join coz_org_info coi on t1.supply_user_id = coi.user_id
               left join coz_server3_cate_dealstatus_statistic_detail dsd on dsd.supply_user_id = coi.user_id
               inner join coz_cattype_sd_path cdp on t1.sd_path_guid = cdp.guid
               inner join coz_lgcode_fixed_data lfd on cdp.lgcode_guid = lfd.guid
      where t1.biz_guid = '{bizGuid}'
        and t1.del_flag = '0'
      union all
      select coi.org_ID                       as orgID
           , left(coi.create_time, 19)        as orgCreateTime
           , left(lfd.login_sysname, 19)      as orgLoginSysName
           , coi.name                         as orgName
           , concat('(+86)', coi.phonenumber) as orgPhone
      from coz_server3_cate_dealstatus_statistic t1
               inner join coz_demand_request dr on t1.biz_guid = dr.guid
               inner join coz_demand_request_supply drs on dr.guid = drs.request_guid
               left join coz_demand_request_supply_server3 drss3 on drs.guid = drss3.request_supply_guid
               inner join coz_category_supplier cs on drs.supplier_guid = cs.guid
               inner join coz_org_info coi on cs.user_id = coi.user_id
               inner join coz_cattype_sd_path cdp on t1.sd_path_guid = cdp.guid
               inner join coz_lgcode_fixed_data lfd on cdp.lgcode_guid = lfd.guid
      where t1.biz_guid = '{bizGuid}'
        and t1.del_flag = '0'
        and t1.dstatus in (211, 213)
        and dr.done_flag = '0') t
order by t.orgID desc
limit 1
;



