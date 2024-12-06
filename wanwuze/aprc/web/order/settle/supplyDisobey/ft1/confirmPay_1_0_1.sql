-- ##Title web-结算管理-确认处罚收取
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-结算管理-确认处罚收取
-- ##CallType[ExSql]

-- ##input judgeFeeGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_judge_fee
set 
update_by='0'
,confirm_pay_time=now()
,confirm_pay_flag='2'
,update_by='{curUserId}'
,update_time=now()
,pay_time=now()
,pay_status=3
,pay_type=3
where guid='{judgeFeeGuid}' and pay_type<>'0' and pay_time is not null
