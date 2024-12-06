-- ##Title web-新增机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增机构名称
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgName string[50] NOTNULL;签约主体(1：机构，2：个人)，必填
-- ##input type string[1] NULL;机构路径guid，必填

insert into coz_org_info(guid,name,type,user_id,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,'{orgName}'
,'{type}'
,''
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_cattype_fixed_data t
where not exists(select 1 from coz_org_info where name='{orgName}' and del_flag='0')
limit 1
;