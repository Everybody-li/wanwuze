-- ##Title web-查询板块配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询板块配置列表
-- ##CallType[QueryData]

-- ##input plateFDCode string[600] NOTNULL;板块guid(会有多个，为固化库guid），必填



select
t.plate_formal_guid as plateGuid
,t.plate_formal_alias as plateAlias
,t.plate_code as plateFDCode
,t1.supplier_guid as supplierGuid
,t.model_guid
,CONCAT('{ChildRows_aprc\\java\\supplier\\model\\getModelPlateFields_1_0_1:plateGuid=''',t.plate_formal_guid,''' and model_guid=''',t.model_guid,'''}') as `fields`
from
coz_category_supplier_model_plate t
left join
coz_category_supplier_model t1
on t.model_guid=t1.guid
where
t1.supplier_guid in ({supplierGuid}) and t.plate_code in ({plateFDCode}) and t.del_flag='0' and t.status='1'
group by t.plate_formal_guid,t.plate_formal_alias,t.plate_code,t1.supplier_guid,t.model_guid