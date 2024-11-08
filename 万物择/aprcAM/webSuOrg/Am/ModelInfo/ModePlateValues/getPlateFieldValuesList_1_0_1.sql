-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-查询型号详情-获取板块字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询
-- ##Describe 表名：coz_category_supplier_am_model_plate
-- ##Describe 排序：字段名称的顺序升序
-- ##CallType[QueryData]

-- ##CustomFormatterColumns[{column:[plateFieldValue]/column}{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\app\demand\dReq\plates\codeToPathName_1_0_1&DBC=w_a&{Value}]/url}];

select
t.plate_field_formal_guid as plateFieldGuid
,t.guid as plateFieldValueGuid
,{file[aprc/app/demand/dReq/plates/codeCondition_1_0_1.sql]/file} as plateFieldValue
,t.plate_field_value as plateFieldValueOriginal
from
coz_category_supplier_am_model_plate t
where 
t.model_guid='{modelGuid}' and t.del_flag='0'  and t.status ='1'