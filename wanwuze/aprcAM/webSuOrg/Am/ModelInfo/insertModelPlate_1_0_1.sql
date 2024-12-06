-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-创建型号板块字段内容
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 新增
-- ##Describe 表名：coz_category_supplier_am_model_plate t1
-- ##CallType[ExSql]

-- ##input modelGuid char[36] NOTNULL;同接口1该字段值
-- ##input supplierGuid string[50] NOTNULL;供方品类guid
-- ##input plateGuid string[50] NOTNULL;板块名称guid
-- ##input plateAlias string[50] NOTNULL;板块名称
-- ##input plateNorder string[50] NOTNULL;板块名称排序
-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid
-- ##input plateFieldAlias string[50] NOTNULL;字段名称别名
-- ##input plateFieldOperation enum[1,2,3,4,5] 字段名称操作设置：1-单选框(需要额外请求接口获取字段内容数据)，2-复选框(需要额外请求接口获取字段内容数据)，3-填写文本框，4-图片上传，5-文档上传;
-- ##input plateFieldNorder string[50] NOTNULL;板块名称排序
-- ##input plateFieldValue string[100] NOTNULL;用户填写的值，存具体内容，例如输入的字符内容或者图片/文件模板地址
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input plateFieldContentCode string[36] NULL;固化字段内容值code
-- ##input plateFieldValueRemark string[200] NULL;板块字段业务扩展值，非必填

insert into coz_category_supplier_am_model_plate
( guid
, model_guid
, plate_formal_guid
, plate_formal_alias
, plate_norder
, plate_field_formal_guid
, plate_field_formal_alias
, plate_field_norder
, plate_field_value
, plate_field_value_remark
, plate_field_content_gc
, operation
, status
, version
, del_flag
, create_by
, create_time
, update_by
, update_time)
select uuid()                                                                            as guid
     , '{modelGuid}'                                                                     as model_guid
     , '{plateGuid}'                                                                     as plate_formal_guid
     , '{plateAlias}'                                                                    as plate_formal_alias
     , '{plateNorder}'                                                                   as plate_norder
     , '{plateFieldGuid}'                                                                as plate_field_formal_guid
     , '{plateFieldAlias}'                                                               as plate_field_formal_alias
     , '{plateFieldNorder}'                                                              as plate_field_norder
     , if('{plateFieldCode}' in ('f00051','f00062'), '{plateFieldValue}' * 100, '{plateFieldValue}') as plate_field_value
     , '{plateFieldValueRemark}'                                                         as plate_field_value_remark
     , '{plateFieldContentCode}'                                                         as plateFieldContentCode
     , '{plateFieldOperation}'                                                           as operation
     , '1'                                                                               as status
     , '1'                                                                               as version
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
;
