-- ##Title 新增，多条
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 新增，多条
-- ##CallType[ExSql]

-- ##input requestPriceGuid char[36] NOTNULL;需求guid，必填
-- ##input modelGuid char[36] NOTNULL;型号guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_demand_request_price_plate(guid,request_price_guid,plate_formal_guid,plate_formal_alias,plate_norder,plate_field_formal_guid,plate_field_formal_alias,plate_field_code,plate_field_norder,plate_field_content_gc,operation,plate_field_value,plate_field_value_remark,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{requestPriceGuid}' as request_price_guid
,plate_formal_guid
,plate_formal_alias
,plate_norder
,plate_field_formal_guid
,plate_field_formal_alias
,plate_field_code
,plate_field_norder
,plate_field_content_gc
,operation
,plate_field_value
,plate_field_value_remark
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_category_supplier_model_price_plate
where
model_guid='{modelGuid}' and del_flag='0'
;
