-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-审批模式-订单验收通过-查看交易有关人员
-- ##Author 卢文彪
-- ##CreateTime 2023-11-22
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic,coz_demand_request,coz_cattype_sd_path,coz_lgcode_fixed_data,coz_org_info,coz_server3_sys_user_dj_bind,sys_user
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;业务guid:订单验收通过-订单guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output demandUserName string[20] ;购方-姓名
-- ##output demandUserPhone string[20] ;购方-手机号码
-- ##output demandSysUserName string[20] ;对接专员(关联需方)-账号名称
-- ##output demandSysNickName string[20] ;对接专员(关联需方)-姓名
-- ##output demandSysUserPhone string[20] ;对接专员(关联需方)-手机号码
-- ##output orgID char[18] ;供应供方-机构账号ID
-- ##output orgCreateTime char[19] 2023-12-12 12:12:12;供应供方-账号开通日期
-- ##output orgLoginSysName string[50] ;供应供方-登录系统
-- ##output orgName string[50] ;供应供方-机构名称
-- ##output orgPhone string[20] ;供应供方-登录手机号
-- ##output supplySysUserName string[20] ;对接专员(关联供应机构)-账号名称
-- ##output supplySysNickName string[20] ;对接专员(关联供应机构)-姓名
-- ##output supplySysUserPhone string[20] ;对接专员关联供应机构)-手机号码

select appu.user_name                    as demandUserName
     , concat('(+86)', appu.phonenumber) as demandUserPhone
     , dsu.user_name                    as demandSysUserName
     , dsu.nick_name                    as demandSysNickName
     , concat('(+86)', dsu.phonenumber) as demandSysUserPhone
     , coi.org_ID                        as orgID
     , left(coi.create_time, 19)         as orgCreateTime
     , left(lfd.login_sysname, 19)       as orgLoginSysName
     , coi.name                          as orgName
     , concat('(+86)', coi.phonenumber)  as orgPhone
     , ssu.user_name                    as supplySysUserName
     , ssu.nick_name                    as supplySysNickName
     , concat('(+86)', ssu.phonenumber) as supplySysUserPhone
from coz_server3_cate_dealstatus_statistic t1
         inner join coz_order corder on t1.biz_guid = corder.guid
         inner join sys_app_user appu on t1.demand_user_id = appu.guid
         inner join coz_cattype_sd_path cdp on t1.sd_path_guid = cdp.guid
         inner join coz_lgcode_fixed_data lfd on cdp.lgcode_guid= lfd.guid
         inner join coz_org_info coi on t1.supply_user_id = coi.user_id
         left join sys_user dsu on t1.demand_sys_user_guid = dsu.user_id
         left join sys_user ssu on t1.supply_sys_user_guid = ssu.user_id
where t1.biz_guid = '{bizGuid}'
  and t1.del_flag = '0'
  and t1.dstatus = '322'
  and corder.pay_status = '2'
  and corder.accept_status = '1'




