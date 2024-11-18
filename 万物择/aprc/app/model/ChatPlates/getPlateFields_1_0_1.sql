-- ##Title app-沟通模式-查询字段名称配置列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe
-- ##CallType[QueryData]

-- ##output fieldGuid char[36] 板块字段名称guid;板块字段名称guid
-- ##output name string[50] 板块字段名称;板块字段名称。
-- ##output alias string[50] 板块字段别称;板块字段别称。
-- ##output fieldFDCode string[50] 板块字段code;板块字段code(非固化的值为空)
-- ##output source int[>=0] 板块字段名称来源;板块字段名称来源（1：固化，2：自建）
-- ##output contentSource int[>=0] 板块字段内容来源;板块字段内容来源（1：固化，2：自建）
-- ##output operation int[>=0] 1;供/需方操作（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传）
-- ##output placeholder string[50] 操作提示语;供/需方操作提示语
-- ##output norder int[>=0] 1;板块字段顺序
-- ##output plateFieldContentCode string[50] 字段内容固化库code,;字段内容固化库code,字段内容是固化时有值
-- ##output fileTemplate string[41] ;字段内容是固化时有值文件/图片模板(下载文件用此字段),样例值:c02cf50d-b05f-43a2-81a2-ab2f0945eeb0.xlxs
-- ##output fileTemplateDisplay string[200] ;字段内容是固化时有值文件展示名称(原始文件名,展示用此字段),样例值:员工模板.xlxs

select
t.guid as fieldGuid
,plate_formal_guid as plateGuid
,(select code from coz_model_fixed_data where code=t.name) as fieldFDCode
,alias
,norder
,source
,content_source as contentSource
,operation
,placeholder
,file_template as fileTemplate
,file_template_display as fileTemplateDisplay
,case when(content_source=3) then (select content_source from coz_model_plate_field_formal where guid=t.demand_pf_formal_guid) else content_source end as plateFieldContentCode
,CONCAT('{ChildRows_aprc\\app\\model\\plates\\getFieldContents_1_0_1:category_guid=''',t.category_guid,''' and cat_tree_code=''',t.cat_tree_code,''' and fieldname=''',t.name,''' and content_source=',t.content_source,'}') as `content`
from
coz_model_chat_plate_field_formal t
where t.del_flag='0' and t.cat_tree_code='{catTreeCode}' and t.category_guid='{categoryGuid}'
order by t.norder,t.id