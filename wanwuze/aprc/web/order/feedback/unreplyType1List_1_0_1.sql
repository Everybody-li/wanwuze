-- ##Title web-查看采购/供应退货退款意见反馈列表-未回复
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看采购/供应退货退款意见反馈列表-未回复
-- ##CallType[QueryData]

-- ##input orderNo string[20] NULL;采购编号（后端模糊搜索），非必填
-- ##input type int[>=0] NOTNULL;反馈类型（1：采购反馈，2：供应反馈），必填

-- ##output feedbackGuid char[36] 订单guid;订单guid
-- ##output feedbackDate string[10] 订单创建日期;订单创建日期（格式：0000-00-00）
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output replyFlag int[>=0] 1;回复标志（0-未回复，1-已回复）


select 
t.guid as feedbackGuid
,left(t.create_time,10) as feedbackDate
,t.category_name as categoryName
,t.order_no as orderNo
,t.reply_flag as replyFlag
,t.content_read_flag as contentReadFlag
from  
coz_order_refund_feedback t
where 
(t.order_no like'%{orderNo}%' or '{orderNo}'='') and t.del_flag='0' and (t.reply_flag='1' or t.reply_flag='0') and (('{type}'='1' and cat_tree_code='demand') or ('{type}'='2' and cat_tree_code='supply'))
order by t.create_time desc
