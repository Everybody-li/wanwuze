-- ##Title web-创建个人用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-创建个人用户
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NOTNULL;联系电话，必填
-- ##input objName string[30] NULL;服务对象姓名，非必填
-- ##input batchUuid string[36] NOTNULL;登录用户id，必填
-- ##input objectGuid char[36] NOTNULL;服务对象guid，必填

set @flag1=(select case when exists(select 1 from coz_target_object where phonenumber='{phonenumber}' and del_flag='0') then '0' else '1' end)
;
insert into coz_target_object(guid,name,phonenumber,batch_uuid,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{objName}'
,'{phonenumber}'
,'{batchUuid}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_guidance_criterion t
where 
@flag1='1'
limit 1
;