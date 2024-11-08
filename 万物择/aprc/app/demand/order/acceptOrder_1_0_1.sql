-- ##Title app-采购-通过验收
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-通过验收
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId char[36] NOTNULL;登录用户id，必填
-- ##input acceptStatus char[1] NOTNULL;需方验收状态(1：验收通过，2：验收不通过)，必填
-- ##input bizRuleType2 char[36] NOTNULL;品类验收规则guid，必填

insert into coz_guidance_user_earnings_detail(guid,user_id,earnings,order_guid,type,status,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,demand_user_id
,(demand_service_fee+supply_service_fee)*0.15
,'{orderGuid}'
,1
,0
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_order t
where t.guid='{orderGuid}' and exists(select 1 from sys_app_user where guid=t.demand_user_id) and not exists(select 1 from coz_order_judge where order_guid='{orderGuid}' and del_flag='0' and result<>'3') and supply_done_flag='1' and accept_way='0' and TIMESTAMPDIFF(DAY,NOW(),accept_deadline)>=0
;

insert into coz_guidance_user_earnings_detail(guid,user_id,earnings,order_guid,type,status,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,supply_user_id
,(demand_service_fee+supply_service_fee)*0.15
,'{orderGuid}'
,2
,0
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_order t
where t.guid='{orderGuid}' and exists(select 1 from sys_app_user where guid=t.supply_user_id) and not exists(select 1 from coz_order_judge where order_guid='{orderGuid}' and del_flag='0' and result<>'3') and supply_done_flag='1' and accept_way='0' and TIMESTAMPDIFF(DAY,NOW(),accept_deadline)>=0
;
insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,t.guid
,ifnull((select status from coz_order_operation_log where order_guid=t.guid order by create_time desc limit 1),'0')
,'5'
,'1'
,''
,'{curUserId}'
,now()
from
coz_order t
where (guid='{orderGuid}' or parent_guid='{orderGuid}') and not exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag='0' and result<>'3') and supply_done_flag='1' and accept_way='0' and TIMESTAMPDIFF(DAY,NOW(),accept_deadline)>=0
;
insert into coz_order_fee_settle(guid,order_guid,type,fee,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{orderGuid}'
,'1'
,supply_fee
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_order t
where t.guid='{orderGuid}' and not exists(select 1 from coz_order_judge where order_guid='{orderGuid}' and del_flag='0' and result<>'3') and supply_done_flag='1' and accept_way='0' and TIMESTAMPDIFF(DAY,NOW(),accept_deadline)>=0 and supply_fee>0
;
update coz_order
set accept_way='1'
,accept_status='{acceptStatus}'
,accept_time=now()
,biz_rule_type2='{bizRuleType2}'
,update_by='{curUserId}'
,update_time=now()
where (guid='{orderGuid}' or parent_guid='{orderGuid}') and not exists(select 1 from coz_order_judge where order_guid='{orderGuid}' and del_flag='0' and result<>'3') and supply_done_flag='1' and accept_way='0' and TIMESTAMPDIFF(DAY,NOW(),accept_deadline)>=0
;

