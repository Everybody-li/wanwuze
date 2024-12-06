-- ##Title app-沟通模式-需方(应聘方)-查看人才信息入库-字段信息
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe
-- ##CallType[QueryData]

-- ##input demandResumeGuid string[500] NOTNULL;需方入库人才信息guid
-- ##input curUserId string[36] NOTNULL;登录用户id


-- ##output status enum[0,1] NOTNULL ;状态:0-失效,1-生效
-- ##output norder int[>0] NOTNULL ;字段顺序
-- ##output alias string[100] NOTNULL ;字段别名
-- ##output plateGuid char[36] NOTNULL ;板块guid
-- ##output fieldGuid char[36] NOTNULL ;字段guid
-- ##output operation char[36] NOTNULL ;字段guid
-- ##output contentSource enum[1,2,3] NOTNULL ;字段内容来源：1-固化，2-自建，3-需方
-- ##output contentFDCode string[200] NOTNULL ;字段内容guid：自建的字段内容值guid或固化字段内容值code
-- ##output fileTemplate string[200] NOTNULL ;文件访问下载
-- ##output fileTemplateDisplay string[200] NOTNULL ;文件展示名称


select
    t.plate_field_norder                     as norder
  , t.plate_field_formal_alias               as alias
  , t.plate_formal_guid                      as plateGuid
  , t.plate_field_formal_guid                as fieldGuid
  , t.operation
  , t1.content_source                        as contentSource
  , t1.file_template                            as fileTemplate
  , t1.file_template_display                    as fileTemplateDisplay
  , CONCAT('{ChildRows_aprc\\app\\chat\\DemandResumeInfo\\plates\\getPlateFieldValues_1_0_1:fieldGuid=''',
           t.plate_field_formal_guid, '''}') as `values`
  , CONCAT('{ChildRows_aprc\\app\\chat\\DemandResumeInfo\\plates\\getPlateFieldContent_1_0_1:fieldGuid=''',
           t.plate_field_formal_guid, '''}') as `content`
from
    coz_chat_demand_resume_plate                 t
    inner join coz_model_chat_plate_field_formal t1 on t.plate_field_formal_guid = t1.guid
where
      t.demand_resume_guid = '{demandResumeGuid}'
  and t.del_flag = '0'
group by
    t.plate_field_norder, t.plate_field_formal_alias, t.plate_formal_guid, t.plate_field_formal_guid, t.operation