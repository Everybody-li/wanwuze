-- ##Title web-查询字段文件模板
-- ##Author lith
-- ##CreateTime 2024-11-12
-- ##Describe web-查询字段内容配置列表
-- ##CallType[QueryData]

-- ##input plateFieldGuid char[36] NOTNULL;字段guid

-- ##output fileTemplate String[200] ;文件模板下载名称
-- ##output fileTemplateDisplay String[200] ;文件模板展示名称
-- ##output placeholder String[200] ;字段操作提示语

select
    file_template as fileTemplate
  , file_template_display as fileTemplateDisplay
  , placeholder
from
    coz_model_plate_field_formal t
where guid = '{plateFieldGuid}';


