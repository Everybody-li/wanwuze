-- ##Title 审批模式-供方型号-根据型号guid批量查询型号列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询
-- ##Describe coz_category_supplier_am_model_plate t1
-- ##CallType[QueryData]

-- ##input modelGuid string[10240] NOTNULL;型号guid，支持多个
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output modelGuid char[36] 品类类型guid;
-- ##output plates.plateFieldGuid char[36] 字段名称guid;
-- ##output plates.plateFieldValue string[20] 字段内容值;
-- ##output plates.plateFieldContentCode string[6] 字段内容固化值;

select
t.model_guid as modelGuid
,CONCAT('{ChildRows_aprcAM\\Java\\Web\\Modelprice\\getSupplierModelPlateValuesByMGuid_1_0_1:modelGuid=''',t.model_guid,'''}') as `plates`
from
coz_category_supplier_am_model_plate t
where
t.model_guid in ({modelGuid}) and t.del_flag='0' and status='1'
group by t.model_guid