-- ##Title web-设置供/需方操作设置
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-设置供/需方操作设置
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input operation int[>=0] NOTNULL;供/需方操作设置（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传），必填
-- ##input placeholder string[200] NULL;供/需方操作提示语（请输入需要需方填写或者上传时的注意要点），非必填
-- ##input fileTemplate string[200] NULL;图片文件模板，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_model_plate_field 
set operation='{operation}'
,placeholder='{placeholder}'
,file_template='{fileTemplate}'
,publish_flag=0
where guid='{plateFieldGuid}'
;