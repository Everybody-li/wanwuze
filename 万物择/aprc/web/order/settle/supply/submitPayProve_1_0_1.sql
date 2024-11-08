-- ##Title web-提交付款证明
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-提交付款证明
-- ##CallType[ExSql]

-- ##input settleGuid char[36] NOTNULL;结算guid，必填
-- ##input payType int[>=0] NOTNULL;支付方式（1：微信支付，2：支付宝支付，3：线下打款），必填
-- ##input prove string[600] NOTNULL;付款证明图片url（多个逗号隔开），必填
-- ##input remark string[50] NOTNULL;付款备注，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_order_notice(guid,cat_tree_code,user_id,user_type,order_guid,type,biz_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'supply'
,(select supply_user_id from coz_order where guid=t.order_guid)
,'2'
,order_guid
,4
,'{settleGuid}'
,0
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_order_fee_settle t
where guid='{settleGuid}'
;
update coz_order_fee_settle
set pay_type={payType}
,pay_prove='{prove}'
,pay_remark='{remark}'
,pay_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{settleGuid}'
;
