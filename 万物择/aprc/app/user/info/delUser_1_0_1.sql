-- ##Title 用户-删除用户现存业务关联数据
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 用户-删除用户现存业务关联数据
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;用户id，必填

set @phonenumber=(select phonenumber from sys_app_user where guid='{curUserId}')
;
update sys_app_user
set status='1'
,del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{curUserId}'
;
delete from coz_app_phonenumber where user_id='{curUserId}'
;
delete from coz_serve_org_relate_staff where staff_user_id='{curUserId}'
;
update coz_serve_org_relate_staff_log
set detach_flag='1'
,detach_time=now()
,detach_by='{curUserId}'
,detach_type='2'
,update_by='{curUserId}'
,update_time=now()
where staff_user_id='{curUserId}' and detach_flag='0'
;
delete from coz_serve_user_gain_valid where user_id='{curUserId}'
;
update coz_serve_user_gain_log
set takeback_flag=1
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='5'
,update_by='{curUserId}'
,update_time=now()
where user_id='{curUserId}' and takeback_flag='0'
;
delete from coz_chat_friend where demand_user_id='{curUserId}' or supply_user_id='{curUserId}'
;
delete from coz_serve_org_gain_valid where object_phonenumber=@phonenumber
;
delete from coz_serve_user_gain_valid t5 where exists(select 1 from coz_serve_org_gain_log where t5.seorg_glog_guid=guid and object_phonenumber=@phonenumber)
;
update coz_serve_user_gain_log t6
set takeback_flag=1
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='5'
,update_by='{curUserId}'
,update_time=now()
where  exists(select 1 from coz_serve_org_gain_log where t6.seorg_glog_guid=guid and object_phonenumber=@phonenumber) and takeback_flag='0'
;
update coz_serve_org_gain_log
set takeback_flag=1
,takeback_time=now()
,takeback_by='{curUserId}'
,takeback_type='5'
,update_by='{curUserId}'
,update_time=now()
where object_phonenumber=@phonenumber and takeback_flag='0'
;