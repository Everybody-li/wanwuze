-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-查询型号详情-获取板块字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询
-- ##Describe 表名：coz_category_supplier_am_model_plate
-- ##Describe 排序：字段名称的顺序升序
-- ##CallType[QueryData]

select
t.plate_formal_guid as plateGuid
,t.plate_field_formal_guid as plateFieldGuid
,t.plate_field_formal_alias as plateFieldAlias
,t.plate_field_norder as plateFieldNorder
,t.operation as plateFieldOperation
,t.plate_field_content_gc as plateFieldContentCode
,t.plate_field_code as plateFieldCode
,t.plate_field_value_remark as fieldBizGuid
,CONCAT('{ChildRows_aprcAM\\webSuOrg\\Am\\ModelInfo\\ModePricePlateValues\\getPlateFieldValuesList_1_0_1:plateFieldGuid=''',t.plate_field_formal_guid,'''}') as `values`
from
coz_category_supplier_am_model_price_plate t
where 
t.model_guid='{modelGuid}' and t.del_flag='0'  and t.status ='1'
group by t.plate_formal_guid,t.plate_field_formal_guid,t.plate_field_formal_alias,t.plate_field_norder,t.operation,t.plate_field_content_gc,t.plate_field_code
order by t.plate_field_norder