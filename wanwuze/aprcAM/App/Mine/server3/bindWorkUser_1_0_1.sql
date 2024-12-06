-- ##Title app-我的-操作指导-授权指导-app用户绑定工作人员
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 前置条件:入参工作编号在t1中存在,且工作编号对应的用户id与当前登录用户未绑定
-- ##Describe 符合前置条件则进行绑定,否则不绑定,并返回提示语:工作编号不存在或您已与该工作人员绑定
-- ##Describe 数据逻辑:新增t2,t3
-- ##Describe 表名： sys_user_extra t1,coz_server3_sys_user_dj_bind t2,coz_server3_sys_user_dj_bind_log t3
-- ##CallType[QueryData]

-- ##input workNo char[6] NOTNULL;工作(对接)专员的工作编号
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果是否成功:0-否,1-是
-- ##output msg string[300] 提示语;工作编号不存在或您已与该工作人员绑定

set @Flag1=(select case when exists(select 1 from coz_server3_sys_user_dj_bind where binded_user_id='{curUserId}' and user_guid=(select a.user_guid from sys_user_extra a inner join sys_user b on a.user_guid=b.user_id where a.ex_value='{workNo}' and a.ex_key='1' and b.del_flag='0' and b.status='0')) then '0' else '1' end)
;
set @Flag2=(select case when exists(select 1 from sys_user_extra where ex_value='{workNo}' and ex_key='1') then '1' else '0' end)
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
,t.user_guid
,'1'
,'{curUserId}'
,now()
,'{curUserId}'
from
sys_user_extra t
where (t.ex_value='{workNo}') and @Flag1='1' and @Flag2='1'
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
,t.user_guid
,'1'
,'1'
,'{curUserId}'
,now()
,'{curUserId}'
,'0'
from
sys_user_extra t
where (t.ex_value='{workNo}') and @Flag1='1' and @Flag2='1'
limit 1
;
select 
case when (@Flag1='1' and @Flag2='1') then '1' else '0' end as okFlag
,case when (@Flag1='1' and @Flag2='1') then '' else '工作编号不存在或您已与该工作人员绑定' end as msg