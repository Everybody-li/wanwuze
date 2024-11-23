-- ##Title web-设置供/需方操作设置
-- 使用方:WebAPP
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-设置供/需方操作设置
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input operation int[>=0] NOTNULL;供/需方操作设置（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传），必填
-- ##input placeholder string[200] NULL;供/需方操作提示语（请输入需要需方填写或者上传时的注意要点），非必填
-- ##input fileTemplate string[41] NULL;图片文件模板,将原始文件名称替换成一个guid(通过接口:/guid?OnlyTagReturn=true获取),样例值:c02cf50d-b05f-43a2-81a2-ab2f0945eeb0.xlxs,文件上传时FileName传此值(例如:/UpLoadFile?FileName=c02cf50d-b05f-43a2-81a2-ab2f0945eeb0.xlxs&FilePath=aprc\plate\files\&AppendSize=10893&AppendComplete=true)
-- ##input fileTemplateDisplay string[200] NULL;图片文件原始文件名,样例值:员工模板.xlxs
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @categoryGuid = null,@cat_tree_code = null;

select category_guid, cat_tree_code
into @categoryGuid,@cat_tree_code
from
    coz_model_chat_plate_field
where guid = '{plateFieldGuid}';

update coz_category_chat_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
  , affect_status = '1'
where category_guid = @categoryGuid and publish_flag = '2';

update coz_model_chat_plate_field
set
    operation='{operation}'
  , placeholder='{placeholder}' {dynamic:fileTemplate[, file_template='{fileTemplate}' ]/dynamic}
  {dynamic:fileTemplateDisplay[, file_template_display='{fileTemplateDisplay}']/dynamic}
  , publish_flag=0
where guid = '{plateFieldGuid}'
;