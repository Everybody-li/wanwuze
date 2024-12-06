-- ##Title app-供应-查询需求范围开关
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询需求范围开关
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output rangeFlag int[>=0] 1;需求范围开关（0：关闭，1：开启）

select
range_flag as rangeFlag
,case when(user_price_mode='1' and range_flag='0') then '2' else user_price_mode end as userPriceMode
,case when (exists(select 1 from coz_category_supplier_bill where supplier_guid='{supplierGuid}' and del_flag='0' and status='1')) then '1' else '0' end as billPlateHasValue
,case when (exists(select 1 from coz_category_supplier_model where supplier_guid='{supplierGuid}' and del_flag='0')) then '1' else '0' end as modelPlateHasValue
from
coz_category_supplier
where 
guid='{supplierGuid}' and del_flag='0'
;