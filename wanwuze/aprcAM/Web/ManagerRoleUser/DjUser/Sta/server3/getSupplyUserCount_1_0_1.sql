-- ##Title web-运营经理操作管理-交易对接管理-对接专员信息管理-供方对接管理-供方对接对象管理-列表上方-括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询对接专员绑定的供方用户数量
-- ##Describe coz_server3_sys_user_dj_bind t1,sys_app_user t2
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(对接专员用户id)
-- ##input phonenumber string[100] NULL;姓名或手机号(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] ;对接专员数量

select
count(1) as totalNum
from
coz_server3_sys_user_dj_bind t
inner join
sys_weborg_user t1
on t.binded_user_id=t1.guid
where 
t.user_guid= '{targetUserId}' and t.user_type='2' and t1.del_flag='0' and t1.status='0' and (t1.nick_name like '%{phonenumber}%' or t1.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
