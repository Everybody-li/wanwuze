-- ##Title app-供应-确认处理完成
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-确认处理完成
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填

set @addminute=(select day from coz_category_deal_deadline where category_guid=(select category_guid from coz_order where guid='{orderGuid}') and del_flag=0 limit 1)
;
insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,'{orderGuid}'
,ifnull((select status from coz_order_operation_log where order_guid='{orderGuid}' order by create_time desc limit 1),'0')
,'4'
,'2'
,''
,'{curUserId}'
,now()
;
update coz_order
set supply_done_flag='1'
,supply_done_time=now()
,accept_deadline=DATE_ADD(now(),interval @addminute HOUR)
,biz_rule_type3='c9b59b33-7374-11ec-a478-0242ac120003'
,update_by='{curUserId}'
,update_time=now()
,accept_cal_remark=concat(now(),'供方验收通过时品类验收期限为',@addminute,'小时')
where guid='{orderGuid}' and not exists(select 1 from coz_order_judge where order_guid='{orderGuid}' and del_flag='0')
;
