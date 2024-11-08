-- ##Title 需求-型号-查询供方报价内容
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-型号-查询供方报价内容
-- ##CallType[QueryData]

-- ##input requestPriceGuid char[36] NOTNULL;型号guid，必填
-- ##input plateFieldCode string[600] NULL;板块名称code(可能会有多个)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.request_price_guid as requestPriceGuid
,t.plate_formal_guid as plateGuid
,t.plate_formal_alias as plateAlias
,t.plate_norder as plateNorder
,t.plate_field_formal_guid as plateFieldGuid
,t.plate_field_code as plateFieldFDCode
,t.plate_field_formal_alias as plateFieldAlias
,t.plate_field_norder as plateFieldNorder
,t.plate_field_value as plateFieldValue
from
coz_demand_request_price_plate t
where
t.request_price_guid='{requestPriceGuid}' and t.del_flag='0' and (t.plate_field_code in ({plateFieldCode}) or {plateFieldCode}='')