-- ##Title web-运营专员操作管理-供应机构管理-供应机构信息管理-关联对接专员管理-查询当前关联的对接专员信息
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 返回机构用户绑定的t3的用户信息
-- ##Describe 表名： sys_user_extra t1,coz_server3_sys_user_dj_bind t2,sys_user t3
-- ##CallType[QueryData]

-- ##input orgUserId char[36] NOTNULL;机构用户id(供方用户id)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output userName string[30] 账号名称;账号名称
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output nickName string[30] 姓名;姓名
-- ##output nation string[30] 国家/区域;国家/区域
-- ##output phonenumber string[30] 手机号;手机号
-- ##output bindTime string[16] 关联日期;关联日期

select
t1.user_name as userName
,left(t1.create_time,16) as createTime
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
,left(t.create_time,16) as bindTime
from
coz_server3_sys_user_dj_bind t
inner join
sys_user t1
on t.user_guid=t1.user_id
where 
t.binded_user_id= '{orgUserId}' and t1.del_flag='0'
