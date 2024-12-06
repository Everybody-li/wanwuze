-- ##Title app-采购/供应-更新订单消息通知阅读标志为已读_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购/供应-更新订单消息通知阅读标志为已读_1_0_1
-- ##CallType[ExSql]

-- ##input orderNoticeGuid char[36] NOTNULL;订单消息通知guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_order_notice
set read_flag='1'
,update_by='{curUserId}'
,update_time=now()
where guid='{orderNoticeGuid}'