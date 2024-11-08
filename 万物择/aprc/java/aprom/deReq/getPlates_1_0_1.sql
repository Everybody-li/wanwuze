-- ##Title java-审批模式-渠道需求提交-渠道需求是否存在(返回渠道需求guid)
-- ##Author 卢文彪
-- ##CreateTime 2023-12-05
-- ##Describe 表名： coz_aprom_pre_demand_request
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;渠道需求guid

-- ##output guid char[36] 主键guid;主键guid
-- ##output requestGuid char[36] 需求guid;需求guid
-- ##output plateGuid char[36] 板块名称guid;板块名称guid
-- ##output plateAlias string[50] 板块别名;板块别名
-- ##output plateCode string[50] 板块字段名称code;板块字段名称code(固化时有值)
-- ##output plateNorder int[>=0] 1;板块名称顺序
-- ##output plateFieldGuid char[36] 板块字段名称guid;板块字段名称guid
-- ##output plateFieldAlias string[50] 板块字段名称别名;板块字段名称别名
-- ##output plateFieldCode string[50] 板块字段名称code;板块字段名称code(固化时有值)
-- ##output plateFieldNorder int[>=0] 1;板块字段名称顺序
-- ##output plateFieldValue string[200] 板块字段内容值;板块字段内容值
-- ##output plateFieldContentCode string[200] 板块字段内容固化code;板块字段内容固化code(字段内容来源是系统固化时有值)
-- ##output plateFieldOperation enum[1,2,3,4,5] 1;板块字段值操作设置（1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传）
-- ##output plateFieldRelateFieldGuid string[36] NOTNULL;字段内容关联的字段名称guid


select 
guid
, request_guid as requestGuid
, plate_formal_guid as plateGuid
, plate_formal_alias as plateAlias
, plate_code as plateCode
, plate_norder as plateNorder
, plate_field_formal_guid as plateFieldGuid
, plate_field_formal_alias as plateFieldAlias
, plate_field_code as plateFieldCode
, plate_field_norder as plateFieldNorder
, plate_field_content_gc as plateFieldContentCode
, operation as plateFieldOperation
, plate_field_value as plateFieldValue
from coz_aprom_pre_demand_request_plate
where request_guid= '{requestGuid}'
  and del_flag = '0'
  and status = '1';