-- ##Title web-新增机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增机构名称
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgName string[50] NOTNULL;签约主体(1：机构，2：个人)，必填

set @userid=uuid()
;
insert into coz_org_info(guid,name,user_id,del_flag,create_by,create_time,update_by,update_time,org_ID)
select
UUID()
,'{orgName}'
,@userid
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
,concat((now()+0),left(CEILING(RAND()*9000+1000),4))
;
insert into sys_weborg_user(guid,user_name,nick_name,phonenumber,del_flag,create_by,create_time,update_by,update_time)
select
@userid
,'{orgName}'
,'{orgName}'
,''
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
;