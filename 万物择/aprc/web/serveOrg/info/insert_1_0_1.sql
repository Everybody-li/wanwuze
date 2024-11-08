-- ##Title web-新增机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增机构名称
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgName string[50] NOTNULL;机构名称，必填

set @code=left(rand()*10000000000,6)
;
set @flag1=(select case when not exists(select 1 from coz_serve_org where user_name='{seorgName}' and guid<>'{seorgGuid}' and del_flag='0') then '1' else '0' end)
;
set @flag2=(select case when not exists(select 1 from coz_serve_org where code=@code and del_flag='0') then '1' else '0' end)
;
insert into coz_serve_org(guid,user_name,phonenumber,code,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{seorgName}' as user_name
,'' as phonenumber
,case when (@flag2='1') then @code else left(rand()*10000000000,6) end as code
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1'
limit 1
;