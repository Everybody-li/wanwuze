-- ##Title app-统计未读反馈回复数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看采购/供应退货退款意见反馈列表-未回复
-- ##CallType[QueryData]

-- ##input orderNo string[20] NULL;采购编号（后端模糊搜索），非必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output unReadReplyCountType1 int[>=0] 1;采购反馈未读回复数量
-- ##output unReadReplyCountType2 int[>=0] 1;供应反馈未读回复数量


-- select 
-- count(1) as unReadReplyCount
-- ,t.type
-- from  
-- coz_order_refund_feedback t
-- where 
-- t.order_no like'%{orderNo}%' and t.del_flag='0' and t.reply_flag='0' and t.user_id='{userId}'
-- group by t.type

select
(select count(1) from coz_order_refund_feedback where order_no like'%{orderNo}%' and del_flag='0' and reply_flag='0' and user_id='{curUserId}' and cat_tree_code='demand') as unReadReplyCountType1
,(select count(1) from coz_order_refund_feedback where order_no like'%{orderNo}%' and del_flag='0' and reply_flag='0' and user_id='{curUserId}' and cat_tree_code='supply') as unReadReplyCountType2
