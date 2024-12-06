-- ##Title app-我的-操作指导-授权指导-app用户与工作人员解绑
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 前置条件:入参工作编号在t1中存在,且工作编号对应的用户id与当前登录用户未绑定
-- ##Describe 符合前置条件则进行绑定,否则不绑定,并返回提示语:工作编号不存在或您已与该工作人员绑定
-- ##Describe 数据逻辑:物理删除t2,新增t3,类型为解绑
-- ##Describe 表名： sys_user_extra t1,coz_server3_sys_user_dj_bind t2,coz_server3_sys_user_dj_bind_log t3
-- ##CallType[QueryData]

-- ##input workNo char[6] NOTNULL;工作(对接)专员的工作编号
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果是否成功:0-否,1-是
-- ##output msg string[300] 工作编号不存在或您已与该工作人员绑定;提示语

set @Flag1=(select case when exists(select 1 from coz_server3_sys_user_dj_bind where binded_user_id='{curUserId}' and user_guid=(select user_guid from sys_user_extra where ex_value='{workNo}')) then '1' else '0' end)
;
set @Flag2=(select case when exists(select 1 from sys_user_extra where ex_value='{workNo}' and ex_key='1') then '1' else '0' end)
;
set @bindguid=uuid()
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
,t.user_guid
,'1'
,'2'
,'{curUserId}'
,now()
,'{curUserId}'
,'0'
from
coz_server3_sys_user_dj_bind t
where binded_user_id='{curUserId}' and user_guid=(select user_guid from sys_user_extra where ex_value='{workNo}') and @Flag1='1' and @Flag2='1'
limit 1
;
delete from coz_server3_sys_user_dj_bind where binded_user_id='{curUserId}' and user_guid=(select user_guid from sys_user_extra where ex_value='{workNo}' limit 1) and @Flag1='1' and @Flag2='1'
;
select 
case when (@Flag1='1' and @Flag2='1') then '1' else '0' end as okFlag
,case when (@Flag1='1' and @Flag2='1') then '' else '工作编号不存在或您已与该工作人员绑定' end as msg