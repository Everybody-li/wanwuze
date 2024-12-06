-- ##Title app-供应-型号-查询型号价格列表-按型号模式
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-查询型号价格列表-按型号模式
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##Title app-供应-型号-查询型号价格列表-按型号模式
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-型号-查询型号价格列表-按型号模式
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
t.guid as modelGuid
,t1.guid as modelPriceGuid
,t.name as modelName
,ifnull(t1.sale_on_flag,0) as salesOnFlag
,
(
select 
a.`plate_field_value` as salesUnit
from 
coz_category_supplier_model_plate a
left join 
coz_model_fixed_data d
on a.plate_field_code=d.code
where
d.code=''f00003'' and  a.model_guid=t.guid and a.del_flag=''0''
limit 1
) as salesUnit
,
(
select 
cast(a.`plate_field_value`/100 as decimal(18,2)) as salesUnit
from 
coz_category_supplier_model_price_plate a
left join 
coz_model_fixed_data d
on a.plate_field_code=d.code
where
d.code in (''f00051'', ''f00062'') and  a.model_price_guid=t1.guid and a.del_flag=''0''
limit 1
) as price
,case when exists(select 1 from coz_category_supplier_model_price_plate where status=''0'' and model_price_guid=t.guid) then ''0'' else ''1'' end as valueStatus
from
coz_category_supplier_model t
left join
coz_category_supplier t2
on t.supplier_guid=t2.guid
left join
coz_category_supplier_model_price t1
on t.guid=t1.model_guid and t1.del_flag=''0''
where t.supplier_guid=''{supplierGuid}'' and t2.user_id=''{curUserId}'' and t.del_flag=''0''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;