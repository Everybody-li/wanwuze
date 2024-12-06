-- ##Title app-采购-通过验收
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-通过验收
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId char[36] NOTNULL;登录用户id，必填


set @flag1=(select case when exists (select 1 from coz_order where (guid='{orderGuid}') and supply_done_flag='1' and accept_way='0' and accept_status='0') then '1' else '0' end)
;
set @flag2=(select case when exists (select 1 from coz_order a where guid='{orderGuid}' and not exists(select 1 from coz_order_judge where order_guid='{orderGuid}' and del_flag='0' and result<>'3') and TIMESTAMPDIFF(DAY,NOW(),accept_deadline)>=0) then '1' else '0' end)
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
where (guid='{orderGuid}' or parent_guid='{orderGuid}' or guid=@parent_guid) and @flag1='1' and @flag2='1'
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
where (guid='{orderGuid}' or parent_guid='{orderGuid}' or guid=@parent_guid) and @flag1='1' and @flag2='1' and supply_fee>0
;
update coz_order
set accept_way='2'
,accept_status='1'
,accept_time=now()
,biz_rule_type2=(select guid from coz_order_bussiness_rule where type = 2)
,update_by='{curUserId}'
,update_time=now()
where (guid='{orderGuid}' or guid=@parent_guid or parent_guid='{orderGuid}') and @flag1='1' and @flag2='1'
;