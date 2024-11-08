-- ##Title app-供应-型号-查询某一品类型需求范围的型号列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-查询某一品类型需求范围的型号列表
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.guid as modelGuid
,t.name as modelName
,t.supplier_guid as supplierGuid
,case when (exists(select 1 from coz_category_supplier_model_plate a where model_guid=t.guid and status='1')) then '1' else '0' end as modelStatus
from
coz_category_supplier_model t
where t.supplier_guid='{supplierGuid}' and t.del_flag='0' and (t.name like '%{modelName}%' or '{modelName}'='')
order by t.id desc
;