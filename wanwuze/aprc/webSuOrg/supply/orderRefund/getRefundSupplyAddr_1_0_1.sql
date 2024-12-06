-- ##Title app-采购-查询供方退货地址
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询供方退货地址
-- ##CallType[QueryData]

-- ##input orderRefundGuid char[36] NOTNULL;订单退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output nationName string[20] 国家地区;国家地区
-- ##output receiverName string[20] 收货姓名;收货姓名
-- ##output receiverPhone string[20] 收货手机号;收货手机号
-- ##output addr string[200] 退货地址;退货地址（后端将省市区地址拼接起来）
-- ##output createTime string[10] 0000-00-00;提交时间（格式：0000-00-00）

select
t.nation_name as nationName
,t.receiver_name as receiverName
,t.receiver_phone as receiverPhone
,concat(t.province_name,t.city_name,t.district_name,t.addr) as addr
,left(t.create_time,10) as createTime
from
coz_order_refund_supply_addr t
where 
order_refund_guid='{orderRefundGuid}' and del_flag='0'