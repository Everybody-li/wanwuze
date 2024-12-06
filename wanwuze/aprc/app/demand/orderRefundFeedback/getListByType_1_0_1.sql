-- ##Title app-查看采购/供应退货退款意见反馈列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查看采购/供应退货退款意见反馈列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output feedbackGuid char[36] 订单guid;订单guid
-- ##output createTime string[10] 订单创建日期;订单创建日期（格式：0000-00-00）
-- ##output replyFlag int[>=0] 1;回复标志（0-未回复，1-已回复）
-- ##output readFlag int[>=0] 1;回复阅读标志（0-未读，1-已读）

select 
t.guid as feedbackGuid
,left(t.create_time,10) as createTime
,t.reply_flag as replyFlag
,t.reply_content_read_flag as readFlag
from  
coz_order_refund_feedback t
where 
t.user_id='{curUserId}' and t.del_flag='0' and t.cat_tree_code='demand'
order by t.create_time desc

