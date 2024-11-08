-- ##Title 需求-查询供方服务费定价数据-按型号类型
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-查询供方服务费定价数据-按型号类型
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid


select 
t.category_guid as categoryGuid
,t.target_object as targetObject
,t.charge_type as chargeType
,t.mcharge_value * 100 as mchargeValue
,t.nomcharge_value * 100 as nomchargeValue
,case when exists(select 1 from coz_category_supplier_model_price a left join coz_category_supplier_model b on a.model_guid=b.guid left join coz_category_supplier c on b.supplier_guid=c.guid where a.del_flag='0' and b.del_flag='0' and c.category_guid='{categoryGuid}') then '1' else '0' end as hasModelPriceFlag
from
coz_category_service_fee_mt t
where
category_guid='{categoryGuid}' and del_flag='0'
order by id desc
