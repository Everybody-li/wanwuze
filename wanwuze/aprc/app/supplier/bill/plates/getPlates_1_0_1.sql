-- ##Title app-供应-按单-查询供方需求范围内容
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-按单-查询供方需求范围内容
-- ##CallType[QueryData]

-- ##input supplierGuid string[500] NOTNULL;供方品类需求范围Guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.status
,'1' as bizType
,t.plate_norder as norder
,t.plate_formal_alias as alias
,t.plate_formal_guid as plateGuid
,t.plate_code as plateFDCode
,CONCAT('{ChildRows_aprc\\app\\supplier\\bill\\plates\\getPlateFields_1_0_1:plateGuid=''',t.plate_formal_guid,'''}') as `field`
from
coz_category_supplier_bill  t
where
t.supplier_guid='{supplierGuid}' and t.del_flag='0'
group by t.status,t.plate_norder,t.plate_formal_alias,t.plate_formal_guid,t.plate_code;