-- ##Title 查询反馈信息列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询反馈信息列表
-- ##CallType[QueryData]

-- ##input replyFlag int[>=0] NOTNULL;反馈回复标志（0：未回复，1：已回复，2-所有），必填
-- ##input content string[500] NULL;反馈内容（后端支持模糊搜索），非必填
-- ##input userId char[36] NOTNULL;APP用户ID
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output feedbackGuid char[36] 反馈guid;反馈guid
-- ##output content string[30] 反馈内容;反馈内容
-- ##output createTime string[30] 反馈日期;反馈日期（格式：0000-00-00）
-- ##output replyFlag int[>=0] 1;反馈回复标志（0：未回复，1：已回复）
-- ##output replyTime string[30] 反馈回复日期;反馈回复日期（格式：0000-00-00）
-- ##output displayFileName string[30] 文件名称;用于展示(上传时是什么名称就展示什么名称)
-- ##output downloadFileUrl string[100] 文件相对路径;用于下载文件

select
t.guid as feedbackGuid
,t.content
,left(t.create_time,10) as createTime
,t.reply_flag as replyFlag
,left(t.reply_time,10) as replyTime
,t.reply_content_read_flag as readFlag
,t.file_ori_name as displayFileName
,t.file_guid as downloadFileUrl
from
coz_feedback t
where
(t.reply_flag={replyFlag} or {replyFlag}=2) and
(t.content='%{content}%' or '{content}'='') and del_flag='0' and user_id='{userId}'
order by t.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};
;
