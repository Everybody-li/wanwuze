-- ##Title web-查看回复详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看回复详情
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
-- ##output userNation string[50] 用户区号;用户区号
-- ##output userPhonenumber string[50] 用户联系电话;用户联系电话（账号名称也是手机号）
-- ##output userName string[50] 用户姓名;用户姓名

update coz_order_refund_feedback
set content_read_flag='2'
,content_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{feedbackGuid}' and (content_read_flag='0' or content_read_flag='1')
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
,t1.nation as userNation
,t1.phonenumber as userPhonenumber
,t1.user_name as userName
,t.imgs
from  
coz_order_refund_feedback t
left join
sys_app_user t1
on t.user_id=t1.guid
where 
t.guid='{feedbackGuid}'

