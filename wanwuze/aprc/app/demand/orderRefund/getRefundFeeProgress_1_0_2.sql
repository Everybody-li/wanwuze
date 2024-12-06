-- ##Title app-供应-查询需方退货证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询需方退货证明
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output orderGuid char[36] 订单guid;
-- ##output refundFee int[>=0] 可退款金额（后端除以100并保留两位小数）;
-- ##output confirmRefundPayFlag enum[1,2] 退款支付标志（0：未支付，1：已支付）;
-- ##output confirmRefundPayProve string[600] 退款支付证明图片，则多个逗号隔开;
-- ##output confirmRefundPayTime char[19] 退款支付时间;
-- ##output payRemark char[36] 付款证明说明(后端拼接内容：{退款到账时间} + {t1.支付类型} + “退回“ + {退款金额});


update coz_order_refund
set refund_pay_read_flag='2'
  , update_by='{curUserId}'
  , update_time=now()
where order_guid = '{orderGuid}'
  and refund_pay_read_flag = '1'
;
update coz_order_cancel
set refund_pay_read_flag='2'
  , update_by='{curUserId}'
  , update_time=now()
where order_guid = '{orderGuid}'
  and refund_pay_read_flag = '1'
;
select t.order_guid                                            as orderGuid
     , CAST((t.refund_fee / 100) AS decimal(18, 2))            as refundFee
     , t.confirm_refund_pay_flag                               as confirmRefundPayFlag
     , t.confirm_refund_pay_prove                              as confirmRefundPayProve
     , left(t.confirm_refund_pay_time, 10)                     as confirmRefundPayTime
     , concat(left(t.confirm_refund_pay_time, 16),
              case when (t1.pay_type = '1') then '微信' when (t1.pay_type = '2') then '支付宝' else ' ' end, '退回',
              cast(t.refund_fee / 100 as decimal(18, 2)), '元') as payRemark
from coz_order_refund t
         left join
     coz_order t1
     on t.order_guid = t1.guid
where t.order_guid = '{orderGuid}'
  and t.del_flag = '0'
union all
select t.order_guid                                                as orderGuid
     , CAST((t.refund_fee / 100) AS decimal(18, 2))                as refundFee
     , case when (t.refund_pay_status = '2') then '1' else '0' end as confirmRefundPayFlag
     , ''                                                          as confirmRefundPayProve
     , left(t.refund_pay_time, 10)                                 as confirmRefundPayTime
     , concat(left(t.refund_pay_time, 16),
              case when (t1.pay_type = '1') then '微信' when (t1.pay_type = '2') then '支付宝' else ' ' end, '退回',
              cast(t.refund_fee / 100 as decimal(18, 2)), '元')     as payRemark
from coz_order_cancel t
         left join
     coz_order t1
     on t.order_guid = t1.guid
where t.order_guid = '{orderGuid}'
  and t.del_flag = '0'