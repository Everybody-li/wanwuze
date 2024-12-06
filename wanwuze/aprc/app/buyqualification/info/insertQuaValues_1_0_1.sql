-- ##Title 新增资质内容信息，多条
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 新增资质内容信息，多条
-- ##CallType[ExSql]

-- ##input qualificationUserGuid char[36] NOTNULL;品类资质用户表guid（app自己生成uuid），必填
-- ##input plateGuid char[36] NOTNULL;板块名称guid，必填
-- ##input plateAlias string[50] NOTNULL;供方品类表guid，必填
-- ##input plateNorder int[>=0] NOTNULL;板块名称顺序，必填
-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid，必填
-- ##input plateFieldAlias string[50] NOTNULL;板块字段名称别名，必填
-- ##input fieldFDCode string[50] NULL;板块字段名称code(固化时有值)，非必填
-- ##input plateFieldNorder int[>=0] NOTNULL;板块字段名称顺序，必填
-- ##input plateFieldValue string[200] NOTNULL;板块字段内容值，必填
-- ##input fieldContentGc string[200] NULL;板块字段内容固化code(字段内容来源是系统固化时有值)，非必填
-- ##input operation string[200] NOTNULL;板块字段值操作设置（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_category_buy_qualification_user_plate(guid,qualification_user_guid,plate_formal_guid,plate_formal_alias,plate_norder,plate_field_formal_guid,plate_field_formal_alias,plate_field_code,plate_field_norder,plate_field_content_gc,plate_field_value,operation,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{qualificationUserGuid}' as qualification_user_guid
,'{plateGuid}' as plate_formal_guid
,'{plateAlias}' as plate_formal_alias
,'{plateNorder}' as plate_norder
,'{plateFieldGuid}' as plate_field_formal_guid
,'{plateFieldAlias}' as plate_field_formal_alias
,'{fieldFDCode}' as plate_field_code
,'{plateFieldNorder}' as plate_field_norder
,'{fieldContentGc}' as plate_field_content_gc
,'{plateFieldValue}' as plate_field_value
,'{operation}' as operation
,0
,'-1'
,now()
,'-1'
,now()
;
