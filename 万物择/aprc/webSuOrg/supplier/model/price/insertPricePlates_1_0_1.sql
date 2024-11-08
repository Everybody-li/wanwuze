-- ##Title 新增或修改型号的价格信息，多条
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 新增或修改型号的价格信息，多条
-- ##CallType[ExSql]

-- ##input modelGuid char[36] NOTNULL;型号guid，必填
-- ##input modelPriceGuid char[36] NOTNULL;供方品类型号价格表guid
-- ##input plateGuid char[36] NOTNULL;板块名称guid，必填
-- ##input plateAlias string[50] NOTNULL;板块名称别名，必填
-- ##input plateCode string[50] NOTNULL;板块字段名称code(固化时有值)，非必填
-- ##input plateNorder int[>=0] NOTNULL;板块名称顺序，必填
-- ##input plateFieldGuid char[36] NOTNULL;板块类型guid，必填
-- ##input plateFieldCode string[50] NULL;板块字段名称code(固化时有值)，非必填
-- ##input plateFieldAlias string[50] NOTNULL;板块名称别名，必填
-- ##input plateFieldNorder int[>=0] NOTNULL;板块字段名称顺序，必填
-- ##input plateFieldValue string[200] NOTNULL;板块字段内容值，必填
-- ##input plateFieldValueRemark string[200] NULL;板块字段内容值，必填
-- ##input fieldContentGc string[50] NULL;板块字段内容固化code(字段内容来源是系统固化时有值)，非必填
-- ##input operation int[>=0] NOTNULL;板板块字段值操作设置（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


insert into coz_category_supplier_model_price_plate(guid,model_guid,model_price_guid,plate_formal_guid,plate_formal_alias,plate_code,plate_norder,plate_field_formal_guid,plate_field_formal_alias,plate_field_norder,plate_field_code,plate_field_content_gc,plate_field_value,plate_field_value_remark,operation,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{modelGuid}' as model_guid
,'{modelPriceGuid}' as model_price_guid
,'{plateGuid}' as plate_formal_guid
,'{plateAlias}' as plate_formal_alias
,'{plateCode}' as plate_code
,'{plateNorder}' as plate_norder
,'{plateFieldGuid}' as plate_field_formal_guid
,'{plateFieldAlias}' as plate_field_formal_alias
,'{plateFieldNorder}' as plate_field_norder
,'{plateFieldCode}' as plate_field_code
,'{fieldContentGc}' as plate_field_content_gc
,'{plateFieldValue}' as plate_field_value
,'{plateFieldValueRemark}' as plate_field_value_remark
,'{operation}' as operation
,'0' as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
;