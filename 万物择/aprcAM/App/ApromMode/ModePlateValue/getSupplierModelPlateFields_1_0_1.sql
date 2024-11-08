-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-供方信息-查询供方详情-板块名称
-- ##Author 卢文彪
-- ##CreateTime 2023-08-02
-- ##Describe 表名：coz_category_supplier_am_model_price_plate t1
-- ##CallType[QueryData]

select
t.plate_formal_guid as plateGuid
,t.plate_field_formal_guid as plateFieldGuid
,t.plate_field_formal_alias as plateFieldAlias
,t.plate_field_norder as plateFieldNorder
,t.operation as plateFieldOperation
,CONCAT('{ChildRows_aprcAM\\App\\ApromMode\\ModePlateValue\\getSupplierModelPlateFieldValues_1_0_1:plateFieldGuid=''',t.plate_field_formal_guid,'''}') as `values`
from
coz_category_supplier_am_model_price_plate t
where
t.model_guid='{modelGuid}' and t.del_flag='0' and status='1'
group by t.plate_formal_guid,t.plate_field_formal_guid,t.plate_field_formal_alias,t.plate_field_norder,t.operation