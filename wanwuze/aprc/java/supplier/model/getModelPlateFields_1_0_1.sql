-- ##Title web-查询板块配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询板块配置列表
-- ##CallType[QueryData]

select
t.plate_field_code as fieldFDCode
,t.plate_field_formal_alias as fieldAlias
,t.plate_formal_guid as plateGuid
,t.plate_field_formal_guid as fieldGuid
,pff.demand_pf_formal_guid as dePFieldGuid
,t.model_guid
,CONCAT('{ChildRows_aprc\\java\\supplier\\model\\getModelPlateFieldValues_1_0_1:fieldGuid=''',t.plate_field_formal_guid,''' and model_guid=''',t.model_guid,'''}') as `values`
from
coz_category_supplier_model_plate t
inner join
coz_model_plate_field_formal pff
on t.plate_field_formal_guid = pff.guid
left join
coz_category_supplier_model t1
on t.model_guid=t1.guid
where
t1.supplier_guid in ({supplierGuid}) and t.plate_code in ({plateFDCode}) and t.del_flag='0' and t.status='1'
group by t.plate_field_code,t.plate_field_formal_alias,t.plate_formal_guid,t.plate_field_formal_guid,t.model_guid