-- ##Title 新增渠道需求内容
-- ##Author lith
-- ##CreateTime 2023-12-04
-- ##Describe 新增渠道需求内容
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;需求guid
-- ##input plateGuid char[36] NOTNULL;板块名称guid
-- ##input plateAlias string[50] NOTNULL;板块别名
-- ##input plateCode string[50] NOTNULL;板块字段名称code(固化时有值)
-- ##input plateNorder int[>=0] NOTNULL;板块名称顺序
-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid
-- ##input plateFieldAlias string[50] NOTNULL;板块字段名称别名
-- ##input plateFieldCode string[50] NULL;板块字段名称code(固化时有值)
-- ##input plateFieldNorder int[>=0] NOTNULL;板块字段名称顺序
-- ##input plateFieldValue string[200] NOTNULL;板块字段内容值
-- ##input plateFieldContentCode string[200] NULL;板块字段内容固化code(字段内容来源是系统固化时有值)
-- ##input plateFieldOperation enum[1,2,3,4,5] NOTNULL;板块字段值操作设置（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传）
-- ##input plateFieldRelateFieldGuid string[36] NULL;字段内容关联的字段名称guid
-- ##input curUserId string[36] NOTNULL;登录用户id


insert into coz_aprom_pre_demand_request_plate(guid, request_guid, plate_formal_guid, plate_formal_alias, plate_code,
                                               plate_norder, plate_field_formal_guid, plate_field_formal_alias,
                                               plate_field_code, plate_field_norder, plate_field_content_gc,
                                               plate_field_relate_field_guid, operation,
                                               plate_field_value, create_by, create_time)
select uuid()                        as guid
     , '{requestGuid}'               as request_guid
     , '{plateGuid}'                 as plate_formal_guid
     , '{plateAlias}'                as plate_formal_alias
     , '{plateCode}'                 as plate_code
     , '{plateNorder}'               as plate_norder
     , '{plateFieldGuid}'            as plate_field_formal_guid
     , '{plateFieldAlias}'           as plate_field_formal_alias
     , '{plateFieldCode}'            as plate_field_code
     , '{plateFieldNorder}'          as plate_field_norder
     , '{plateFieldContentCode}'     as plate_field_content_gc
     , '{plateFieldRelateFieldGuid}' as plate_field_relate_field_guid
     , '{plateFieldOperation}'       as operation
     , '{plateFieldValue}'           as plate_field_value
     , '{curUserId}'
     , now()
;
