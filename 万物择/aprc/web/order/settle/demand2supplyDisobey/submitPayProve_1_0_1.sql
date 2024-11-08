-- ##Title web-提交付款证明
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-提交付款证明
-- ##CallType[ExSql]

-- ##input judgeFeeGuid char[36] NOTNULL;裁决费用guid，必填
-- ##input prove string[600] NOTNULL;付款证明图片url（多个逗号隔开），必填
-- ##input remark string[50] NOTNULL;付款备注，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_judge_fee
set pay_prove='{prove}'
,pay_remark='{remark}'
,confirm_pay_flag='2'
,confirm_pay_time=now()
,update_by='{curUserId}'
,update_time=now()
,pay_time=now()
,pay_status=3
,pay_type=3
where guid='{judgeFeeGuid}'
