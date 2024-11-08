-- ##Title web-对接专员操作管理-购方对接管理-购方用户采购管理-查询购方用户绑定记录
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询对接专员绑定的的需方用户绑定记录列表
-- ##Describe 表名： coz_server3_sys_user_dj_bind_log t1,sys_app_user t2
-- ##CallType[QueryData]

-- ##input phonenumber string[50] NULL;姓名或者联系电话(模糊搜索)，非必填
-- ##input targetUserId char[36] NOTNULL;目标用户id(对接专员用户id)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output bindTime string[16] 日期;日期
-- ##output status string[30] 状态;状态
-- ##output nickName string[30] 姓名;姓名
-- ##output phonenumber string[30] 联系电话;联系电话
-- ##output createTime string[16] 注册日期;注册日期

select
left(t.create_time,16) as bindTime
,case when (t.bind_type='1') then '绑定' else '解绑' end as status
,t1.nick_name as nickName
,t1.phonenumber
,left(t1.create_time,16) as createTime
from
coz_server3_sys_user_dj_bind_log t
inner join
sys_app_user t1
on t.binded_user_id=t1.guid
where 
t.user_guid= '{targetUserId}' and t1.del_flag='0' and (t1.nick_name like '%{phonenumber}%' or t1.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};