-- ##Title app-我要反馈（新增反馈）
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-我要反馈（新增反馈）
-- ##CallType[ExSql]

-- ##input userId char[36] NOTNULL;用户id
-- ##input content string[500] NOTNULL;反馈的内容
-- ##input imgs string[2000] NULL;反馈的图片地址，多个逗号隔开
-- ##input fileOriName string[200] NULL;文件原始名称，带后缀，上传目录：APRC/USER/USE_FEEDBACK/FILES/文件名{GUID}首字母/
-- ##input fileGuid string[40] NULL;文件上传名称(一个guid)，带后缀
-- ##input curUserId string[36] NOTNULL;登录用户id

insert into coz_feedback(guid,user_id,reply_user_id,content,reply_content,imgs,file_ori_name,file_guid,reply_time,reply_content_read_time,create_by,create_time,update_by,update_time)
value (uuid(),'{userId}','','{content}','','{imgs}','{fileOriName}','{fileGuid}',null,null,'{curUserId}',now(),'{curUserId}',now())
