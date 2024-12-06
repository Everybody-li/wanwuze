-- ##Title 查询订单支付详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询订单支付详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NULL;订单guid,必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output guid char[36] 订单支付guid;订单支付guid
-- ##output userId char[36] 用户id;用户id
-- ##output channelPayOrderNo string[50] 渠道支付单号;渠道支付单号
-- ##output payOrderCode string[50] 内部支付单号;内部支付单号
-- ##output payStatus string[1] 1;支付状态：0-订单生成,1-支付中,2-支付成功,3-业务处理完成
-- ##output amount int[>=0] 1;内部支付金额

# 非0元支付的也记录到支付记录表
select t.order_code         as orderGuid
     , guid
     , t.user_id            as userId
     , channel_pay_order_no as channelPayOrderNo
     , t.pay_order_code     as payOrderCode
     , t.pay_status         as payStatus
     , t.amount
from pay_order_payment t
where t.order_code = '{orderGuid}'
  and t.del_flag = '0'

