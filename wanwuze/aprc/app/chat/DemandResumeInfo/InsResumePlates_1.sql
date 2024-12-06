-- ##Title app-沟通模式-需方(应聘方)-个人信息入库-个人信息-板块字段信息
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe
-- ##CallType[ExSql]

-- ##input demandResumeGuid char[36] NOTNULL;需方个人信息入库guid
-- ##input plateGuid char[36] NOTNULL;板块名称guid字段
-- ##input plateAlias string[20] NOTNULL;供方品类表guid字段
-- ##input plateCode string[20] NOTNULL;板块字段名称code(固化时有值)字段
-- ##input plateNorder int[>=0] NOTNULL;板块名称顺序字段
-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid字段
-- ##input plateFieldAlias string[100] NOTNULL;板块字段名称别名字段
-- ##input plateFieldFDCode string[36] NULL;板块字段名称code(固化时有值)，非必填
-- ##input plateFieldNorder int[>=0] NOTNULL;板块字段名称顺序字段
-- ##input plateFieldValue string[200] NOTNULL;板块字段内容值字段
-- ##input plateFieldValueRemark string[200] NOTNULL;板块字段内容值字段备注(当是图片或文件类时,存图片文件原始名称)
-- ##input contentFDCode string[200] NULL;板块字段内容固化code(字段内容来源是系统固化时有值)，非必填
-- ##input operation enum[1,2,3,4,5] NOTNULL;板块字段值操作设置（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传）字段
-- ##input contentSource enum[1,2,3] NOTNULL;字段内容来源：1-固化，2-自建，3-需方
-- ##input fileTemplate string[200] NULL;文件访问下载
-- ##input fileTemplateDisplay string[200] NULL;文件展示名称
-- ##input curUserId string[36] NOTNULL;登录用户id字段


insert into
    coz_chat_demand_resume_plate( guid, demand_resume_guid, plate_formal_guid, plate_formal_alias, plate_code
                                , plate_norder
                                , plate_field_formal_guid, plate_field_formal_alias, plate_field_code
                                , plate_field_norder
                                , plate_field_content_gc, operation, plate_field_value
                                , status, status_time
                                , del_flag, create_by, create_time )
select
    uuid()               as guid
  , '{demandResumeGuid}' as demand_resume_guid
  , '{plateGuid}'        as plate_formal_guid
  , '{plateAlias}'       as plate_formal_alias
  , '{plateCode}'        as plate_code
  , '{plateNorder}'      as plate_norder
  , '{plateFieldGuid}'   as plate_field_formal_guid
  , '{plateFieldAlias}'  as plate_field_formal_alias
  , '{plateFieldFDCode}' as plate_field_code
  , '{plateFieldNorder}' as plate_field_norder
  , '{contentFDCode}'   as plate_field_content_gc
  , '{operation}'        as operation
  , '{plateFieldValue}'  as plate_field_value
  , '1'                  as status
  , now()                as status_time
  , '0'                  as del_flag
  , '{curUserId}'        as create_by
  , now()                as create_time
;
