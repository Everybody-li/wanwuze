-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-查询型号详情-获取板块列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询：复合接口，嵌套结构，需返回4层
-- ##Describe 表名：coz_category_supplier_am_model,coz_category_supplier_am_model_price_plate
-- ##Describe 排序：板块的顺序升序
-- ##CallType[QueryData]

-- ##input modelGuid char[36] NOTNULL;型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output modelGuid char[36] 型号guid;
-- ##output modelName char[36] 型号名称;
-- ##output supplyCompanyName string[50] 供应主体;
-- ##output plates.plateGuid char[36] 板块guid;
-- ##output plates.plateAlias string[20] 板块名称别名;
-- ##output plates.plateNorder int[>0] 板块名称排序;
-- ##output plates.fields.plateFieldGuid char[36] 字段名称guid;
-- ##output plates.fields.plateFieldAlias int[>0] 字段名称别名;
-- ##output plates.fields.plateFieldNorder int[>0] 字段名称排序;
-- ##output plates.fields.plateFieldOperation enum[1,2,3,4,5] 字段名称操作设置：1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传;
-- ##output plates.fields.plateFieldContentCode string[6] 字段内容固化code;
-- ##output plates.fields.plateFieldCode string[6] 固化字段code;
-- ##output plates.fields.fieldBizGuid string[36] fieldBizGuid;fieldBizGuid
-- ##output plates.fields.values.plateFieldValueGuid string[100] 字段内容值guid;
-- ##output plates.fields.values.plateFieldValue string[200] 字段内容显示值，显示在页面上，例如：福建省厦门市;
-- ##output plates.fields.values.plateFieldValueOriginal string[200] 字段内容原始值，提交至服务端，例如：350200;


select
t.guid as modelGuid
,t.name as modelName
,t.supply_company_name as supplyCompanyName
,CONCAT('{ChildRows_aprcAM\\webSuOrg\\Am\\ModelInfo\\ModePricePlateValues\\getPlates_1_0_1:modelGuid=''',t.guid,'''}') as `plates`
from
coz_category_supplier_am_model t
where
t.guid ='{modelGuid}' and t.del_flag='0'