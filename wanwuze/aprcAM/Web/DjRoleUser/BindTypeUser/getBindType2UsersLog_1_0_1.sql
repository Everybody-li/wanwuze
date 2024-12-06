-- ##Title web-对接专员操作管理-供方对接管理-供应渠道供应管理-查询供应渠道关联列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询对接专员绑定的的供方用户绑定记录列表
-- ##Describe 表名： coz_server3_sys_user_dj_bind_log t1,coz_org_user t2
-- ##CallType[QueryData]

-- ##input phonenumber string[50] NULL;机构名称或者登录手机号(模糊搜索)，非必填
-- ##input targetUserId char[36] NOTNULL;目标用户id(对接专员用户id)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output bindTime string[16] 日期;日期
-- ##output status string[30] 状态;状态
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统

select
case when (t.bind_type='1') then '绑定' else '解绑' end as status
,t1.org_ID as orgID
,left(t1.create_time,16) as createTime
,t1.name as orgName
,t1.phonenumber
,(select a.login_sysname from coz_lgcode_fixed_data a inner join coz_org_info_lgcode b on b.lgcode_guid=a.guid where b.user_id=t1.user_id and a.del_flag='0' and b.del_flag='0' order by b.id desc limit 1) as supplySystem
,left(t.create_time,16) as bindTime
from
coz_server3_sys_user_dj_bind_log t
inner join
coz_org_info t1
on t.binded_user_id=t1.user_id
where 
t.user_guid= '{targetUserId}' and t1.del_flag='0' and (t1.name like '%{phonenumber}%' or t1.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};

