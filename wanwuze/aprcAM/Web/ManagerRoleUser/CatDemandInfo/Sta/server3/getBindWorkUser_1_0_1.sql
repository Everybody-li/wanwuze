-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-关联对接专员信息-查询
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询需方的对接专员信息
-- ##Describe 表名:coz_server3_sys_user_dj_bind t1,sys_user t3
-- ##CallType[QueryData]

-- ##input demandUserId char[36] NOTNULL;购方(需方)用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output userName string[30] 账号名称;账号名称
-- ##output nickName string[30] 姓名;姓名
-- ##output phonenumber string[30] 手机号;手机号
-- ##output createTime string[16] 账号开通日期;账号开通日期
-- ##output bindTime string[16] 关联日期;关联日期

select
t1.user_name as userName
,t1.nick_name as nickName
,t1.phonenumber
,left(t.create_time,16) as bindTime
,left(t1.create_time,16) as createTime
from
coz_server3_sys_user_dj_bind t
inner join
sys_user t1
on t.user_guid=t1.user_id
where 
t.binded_user_id= '{demandUserId}'
