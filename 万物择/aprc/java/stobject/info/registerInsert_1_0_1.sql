-- ##Title 服务对象-新增个人用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 服务对象-新增个人用户
-- ##CallType[ExSql]

-- ##input userId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NOTNULL;联系电话，必填
-- ##input userName string[30] NOTNULL;服务对象姓名，必填


set @flag1=(select case when exists(select 1 from coz_target_object where phonenumber='{phonenumber}' and del_flag='0') then '0' else '1' end)
;
update coz_target_object
set user_id='{userId}'
,name='{userName}'
where phonenumber='{phonenumber}' and @flag1='0'
;
insert into coz_target_object(guid,user_id,name,phonenumber,batch_uuid,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{userId}'
,'{userName}'
,'{phonenumber}'
,''
,'0'
,'1'
,now()
,'1'
,now()
from
coz_guidance_criterion t
where 
@flag1='1'
limit 1
;