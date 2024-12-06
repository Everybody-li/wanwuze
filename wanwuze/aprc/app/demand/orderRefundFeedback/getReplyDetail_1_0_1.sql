-- ##Title app-采购退货退款意见反馈-查看回复详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购退货退款意见反馈-查看回复详情
-- ##CallType[QueryData]

-- ##input feedbackGuid char[36] NOTNULL;反馈guid，必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output feedbackGuid char[36] 订单guid;订单guid
-- ##output replyDate string[10] 回复日期（格式：0000-00）
-- ##output replyContent string[500] 回复内容;回复内容
-- ##output feedbackDate string[10] 反馈日期;反馈日期（格式：0000-00）
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output replyFlag int[>=0] 1;回复标志（0-未回复，1-已回复）
-- ##output feedbackContent string[50] 反馈事由;反馈事由
-- ##output feedbackContact string[50] 反馈联系人;反馈联系人
-- ##output feedbackPhone string[50] 反馈联系电话;反馈联系电话
-- ##output feedbackNation string[50] 反馈区号;反馈区号

update coz_order_refund_feedback
set reply_content_read_flag='2'
,reply_content_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{feedbackGuid}' and reply_content_read_flag='1'
;
select 
t.guid as feedbackGuid
,left(t.reply_time,10) as replyDate
,t.reply_content as replyContent
,left(t.create_time,10) as feedbackDate
,t.category_name as categoryName
,t.order_no as orderNo
,t.reply_flag as replyFlag
,t.content as feedbackContent
,t.contact_name as feedbackContact
,t.contact_phone as feedbackPhone
,t.nation as feedbackNation
,t.imgs
from  
coz_order_refund_feedback t
where 
t.user_id='{curUserId}' and t.del_flag='0' and t.guid='{feedbackGuid}'

