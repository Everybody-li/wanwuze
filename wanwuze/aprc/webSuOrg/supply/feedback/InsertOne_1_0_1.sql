-- ##Title app-我要反馈（新增反馈）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-我要反馈（新增反馈）
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input content string[500] NOTNULL;反馈的内容，必填
-- ##input imgs string[2000] NULL;反馈的图片地址，多个逗号隔开，非必填

insert into coz_feedback(guid,user_id,user_type,reply_user_id,content,reply_content,imgs,reply_time,reply_content_read_time,create_by,create_time,update_by,update_time)
value (uuid(),'{curUserId}','2','','{content}','','{imgs}',null,null,'{curUserId}',now(),'{curUserId}',now())
