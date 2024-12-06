-- ##Title app-我的-操作指导-查询绑定的工作人员
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 返回当前用户绑定的t3的用户信息
-- ##Describe 表名： sys_user_extra t1,coz_server3_sys_user_dj_bind t2,sys_user t3
-- ##CallType[QueryData]

-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output workNo char[6] 工作编号;工作(对接)专员的工作编号
-- ##output targetUserId char[36] 工作(对接)专员的用户id;工作(对接)专员的用户id
-- ##output nickName string[30] 姓名;姓名
-- ##output phonenumber string[11] 联系电话;联系电话
-- ##output createTime string[19] 授权时间;授权时间

select
(select ex_value from sys_user_extra where user_guid=t.user_guid and ex_key='1' and del_flag='0' limit 1) as workNo
,t.user_guid as targetUserId
,t1.nick_name as nickName
,t1.phonenumber
,left(t.create_time,19) as createTime
from
coz_server3_sys_user_dj_bind t
inner join
sys_user t1
on t.user_guid=t1.user_id
where 
t.binded_user_id= '{curUserId}'
