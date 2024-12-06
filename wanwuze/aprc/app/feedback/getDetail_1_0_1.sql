-- ##Title 查询反馈详情（已回复未回复都用此接口）
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询反馈详情（已回复未回复都用此接口）
-- ##CallType[QueryData]

-- ##input feedbackGuid char[36] NOTNULL;反馈guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output feedbackGuid char[36] 反馈guid;反馈guid
-- ##output content string[30] 反馈内容;反馈内容
-- ##output imgs string[30] 反馈图片地址;反馈图片地址，多个逗号隔开
-- ##output createTime string[10] 反馈日期;反馈日期（格式：0000-00-00）
-- ##output replyTime string[30] 回复日期;回复日期（格式：0000-00-00）
-- ##output replyFlag int[>=0] 1;反馈回复标志（0：未回复，1：已回复）
-- ##output replyContent string[30] 反馈回复内容;反馈回复内容
-- ##output replyContentReadFlag int[>=0] 1;反馈内容查看标志（0：未查看，1：已查看，app端未查看的标识红点）
-- ##output feedbackUserId string[30] 反馈用户id;反馈用户id
-- ##output feedbackUserName string[30] 反馈用户姓名;反馈用户姓名
-- ##output feedbackUserNation string[30] 反馈用户区号;反馈用户区号
-- ##output feedbackUserPhonenumber string[30] 反馈用户手机号;反馈用户手机号

update coz_feedback
set reply_content_read_flag='1'
,reply_content_read_time=now()
,update_by='{curUserId}'
,update_time=now()
where guid='{feedbackGuid}' and reply_content_read_flag='0'
;
select 
t.guid as feedbackGuid
,t.content
,t.imgs
,left(t.create_time,10) as createTime
,t.reply_time as replyTime
,t.reply_flag as replyFlag
,t.reply_content as replyContent
,t.reply_content_read_flag as replyContentReadFlag
,t.user_id as feedbackUserId
,t1.user_name as feedbackUserName
,t1.nation as feedbackUserNation
,t1.phonenumber as feedbackUserPhonenumber
from
coz_feedback t
left join
sys_app_user t1
on t.user_id=t1.guid
where
t.guid='{feedbackGuid}' and t.del_flag='0'
