-- ##Title app-供应-按单-查询报价接单开放值
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-按单-查询报价接单开放值
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
accpet_order_flag as acceptOrderFlag
from
coz_category_supplier
where 
guid='{supplierGuid}' and del_flag='0'

;