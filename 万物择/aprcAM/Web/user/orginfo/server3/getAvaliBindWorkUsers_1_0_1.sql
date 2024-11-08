-- ##Title web-运营专员操作管理-供应机构管理-供应机构信息管理-关联对接专员管理-查询可关联的对接专员信息列表(弹窗)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 返回机构用户绑定的t3的用户信息
-- ##Describe 表名： sys_user_extra t1,coz_server3_sys_user_dj_bind t2,sys_user t3
-- ##CallType[QueryData]

-- ##input workUserNameOrPho string[100] NULL;对接专员姓名或联系电话,模糊搜索
-- ##input orgUserId char[36] NOTNULL;机构用户id(供方用户id)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output workUserId char[36] 对接专员用户id;对接专员用户id
-- ##output userName string[30] 账号名称;账号名称
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output nickName string[30] 姓名;姓名
-- ##output nation string[30] 国家/区域;国家/区域
-- ##output phonenumber string[30] 手机号;手机号

select
t1.user_id as workUserId
,t1.user_name as userName
,left(t1.create_time,16) as createTime
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
from
sys_user t1
inner join
sys_user_role t2
on t1.user_id=t2.user_id
inner join
sys_role t3
on t2.role_id=t3.role_id
where 
t1.del_flag='0' and not exists(select 1 from coz_server3_sys_user_dj_bind where binded_user_id= '{orgUserId}' and user_guid=t1.user_id) and (t1.user_name like '%{workUserNameOrPho}%' or t1.nick_name like '%{workUserNameOrPho}%' or t1.phonenumber like '%{workUserNameOrPho}%' or '{workUserNameOrPho}'='' ) and t1.status='0' and t3.role_key='duijieRole'
order by t1.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};