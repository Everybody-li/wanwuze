-- ##Title web-运营专员操作管理-供应机构管理-供应机构信息管理-关联对接专员管理-查询可关联的对接专员信息列表(弹窗)-选中对接专员-保存
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 前置条件:入参工作编号在t1中未禁用未删除,且与机构用户未绑定
-- ##Describe 符合前置条件则进行绑定,否则不绑定,并返回提示语:对接专员已被删除或您已与该工作人员绑定
-- ##Describe 数据逻辑:与旧的对接专员解除绑定:删除t2,新增t3,关联类型为解绑
-- ##Describe 1.与旧的对接专员解除绑定(若有则执行):删除t2,新增t3,关联类型为解绑
-- ##Describe 2.与新的对接专员进行绑定:新增t2,t3
-- ##Describe 表名： sys_user t1,coz_server3_sys_user_dj_bind t2,coz_server3_sys_user_dj_bind_log t3
-- ##CallType[QueryData]

-- ##input workUserId char[36] NOTNULL;对接专员用户id
-- ##input orgUserId char[36] NOTNULL;机构用户id(供方用户id)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果是否成功:0-否,1-是
-- ##output msg string[300] 工作编号不存在或您已与该工作人员绑定;提示语


set @Flag2=(select case when exists(select 1 from coz_server3_sys_user_dj_bind where binded_user_id='{orgUserId}') then '0' else '1' end)
;
insert into coz_server3_sys_user_dj_bind_log
(
guid
,bind_guid
,user_guid
,user_type
,bind_type
,binded_user_id
,create_time
,create_by
,del_flag
)
select
uuid()
,guid
,user_guid
,'2'
,'2'
,'{orgUserId}'
,now()
,'{curUserId}'
,'0'
from
coz_server3_sys_user_dj_bind
where binded_user_id='{orgUserId}' and @Flag2='0'
limit 1
;
delete from coz_server3_sys_user_dj_bind where binded_user_id='{orgUserId}'  and @Flag2='0' 
;
set @Flag1=(select case when exists(select 1 from coz_server3_sys_user_dj_bind where binded_user_id='{orgUserId}' and user_guid='{workUserId}') then '0' else '1' end)
;
set @bindguid=uuid()
;
insert into coz_server3_sys_user_dj_bind
(
guid
,user_guid
,user_type
,binded_user_id
,create_time
,create_by
)
select
@bindguid
,t1.user_id
,'2'
,'{orgUserId}'
,now()
,'{curUserId}'
from
sys_user t1
where t1.user_id='{workUserId}' and t1.del_flag='0' and t1.status='0' and @Flag1='1' 
limit 1
;
insert into coz_server3_sys_user_dj_bind_log
(
guid
,bind_guid
,user_guid
,user_type
,bind_type
,binded_user_id
,create_time
,create_by
,del_flag
)
select
uuid()
,@bindguid
,t1.user_id
,'2'
,'1'
,'{orgUserId}'
,now()
,'{curUserId}'
,'0'
from
sys_user t1
where t1.user_id='{workUserId}' and t1.del_flag='0' and t1.status='0' and @Flag1='1'
limit 1
;
select 
case when (@Flag1='1') then '1' else '0' end as okFlag
,case when (@Flag1='1') then '' else '对接专员已被删除或您已与该工作人员绑定' end as msg