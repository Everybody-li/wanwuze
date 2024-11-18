-- ##Title web-查询字段设置详情
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-查询字段内容详情
-- ##CallType[QueryData]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output plateFieldGuid char[36] ;字段名称guid
-- ##output plateFieldName string[100] ;字段名称
-- ##output plateFieldSource enum[1,2] ;字段名称来源：1-系统固化，2-型号专员自建
-- ##output fieldContentSource enum[0,1,2,3,4] ;字段内容来源：0-未设置，1-系统固化，2-型号专员自建，3-需方(biz_type=1,cat_tree_code=supply：采购需求配置，其他时候：用户填写)，4-供方(用户填写)
-- ##output catTreeCode enum[demand,supply] ;供需区分，固定取值，采购-demand，供应-supply
-- ##output operation enum[0,1,2,3,4,5] ;供/需方操作设置：0-未设置，1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##output placeholder string[100] ;供/需方操作提示信息
-- ##output fileTemplate string[41] ;文件/图片模板(下载文件用此字段),样例值:c02cf50d-b05f-43a2-81a2-ab2f0945eeb0.xlxs
-- ##output fileTemplateDisplay string[200] ;文件展示名称(原始文件名,展示用此字段),样例值:员工模板.xlxs

select
    t.guid                  as plateFieldGuid
  , case
        when (t.source = 2) then t.name
        else (
                 select name
                 from
                     coz_model_fixed_data
                 where code = t.name
        ) end               as plateFieldName
  , t.source                as plateFieldSource
  , t.cat_tree_code         as catTreeCode
  , t.content_source        as fieldContentSource
  , t.operation
  , t.placeholder
  , t.file_template         as fileTemplate
  , t.file_template_display as fileTemplateDisplay
  , case
        when (t.content_source = '0') then '0'
        when ((t.content_source = '1' or t.content_source = '2') and not exists(select 1
                                                                                from
                                                                                    coz_model_chat_plate_field_content
                                                                                where plate_field_guid = t.guid and del_flag = '0'))
            then '0'
        else '1' end        as contentSetFlag
from
    coz_model_chat_plate_field t
where
      t.guid = '{plateFieldGuid}'
  and t.del_flag = '0'
order by t.id 