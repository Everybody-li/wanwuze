-- ##Title web-查看供应退货退款意见反馈列表-已回复
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看供应退货退款意见反馈列表-已回复
-- ##CallType[QueryData]


-- ##input orderNo string[20] NULL;采购编号（后端模糊搜索），非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填




select 
t.guid as feedbackGuid
,left(t.reply_time,10) as replyDate
,left(t.create_time,10) as feedbackDate
,t.category_name as categoryName
,t.order_no as orderNo
,t.reply_flag as replyFlag
from  
coz_order_refund_feedback t
where 
(t.order_no like'%{orderNo}%' or '{orderNo}'='') and t.del_flag='0' and t.cat_tree_code='supply'  and t.reply_flag='2'

