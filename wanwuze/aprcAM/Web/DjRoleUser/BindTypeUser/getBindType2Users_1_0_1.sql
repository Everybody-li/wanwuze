-- ##Title web-对接专员操作管理-供方对接管理-供应渠道供应管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询对接专员绑定的的供方用户列表
-- ##Describe 表名： coz_server3_sys_user_dj_bind t1,coz_org_user t2,coz_lgcode_fixed_data t3,coz_cattype_supply_path_lgcode t4,coz_cattype_sd_path t5,coz_cattype_fixed_data t6
-- ##CallType[QueryData]

-- ##input phonenumber string[50] NULL;机构名称或者登录手机号(模糊搜索)，非必填
-- ##input targetUserId char[36] NOTNULL;目标用户id(对接专员用户id)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output targetUserId char[36] 目标用户id;目标用户id(对接专员用户id)
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output bindTime string[16] 关联日期;关联日期
-- ##output catMode int[>=0] 1;模式：1-沟通模式，2-交易模式,3-审批模式；
-- ##output sdPathGuid char[36] 采购供应路径guid;
-- ##output supplyUserId char[36] 供方用户id(机构用户id);供方用户id(机构用户id)
-- ##output lgcodeGuid string[36] 供应机构code;供应机构code

select
t.user_guid as targetUserId
,t1.org_ID as orgID
,left(t1.create_time,16) as createTime
,t1.name as orgName
,t1.phonenumber
,t3.login_sysname as supplySystem
,t6.mode as catMode
,left(t.create_time,16) as bindTime
,t5.guid as sdPathGuid
,t.binded_user_id as supplyUserId
,t2.lgcode_guid as lgcodeGuid
from
coz_server3_sys_user_dj_bind t
inner join
coz_org_info t1
on t.binded_user_id=t1.user_id
left join
coz_org_info_lgcode t2
on t2.user_id=t1.user_id
inner join
coz_lgcode_fixed_data t3
on t2.lgcode_guid=t3.guid
inner join
coz_cattype_supply_path_lgcode t4
on t3.login_code=t4.login_code
inner join
coz_cattype_sd_path t5
on t4.supply_path_guid=t5.supply_path_guid
inner join
coz_cattype_fixed_data t6
on t5.cattype_guid=t6.guid
where 
t.user_guid= '{targetUserId}' and t1.del_flag='0' and t2.del_flag='0' and (t1.name like '%{phonenumber}%' or t1.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
order by t1.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};