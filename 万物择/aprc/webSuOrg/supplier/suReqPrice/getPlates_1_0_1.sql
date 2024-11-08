-- ##Title web-查询板块配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询板块配置列表
-- ##CallType[QueryData]


select
t.status
,'2' as bizType
,t.plate_norder as norder
,t.plate_formal_alias as alias
,t.plate_formal_guid as plateGuid
,t.request_price_guid as requestPriceGuid
,CONCAT('{ChildRows_aprc\\webSuOrg\\supplier\\suReqPrice\\getPlateFields_1_0_1:plateGuid=''',t.plate_formal_guid,'''}') as `field`
from
coz_demand_request_price_plate t
where
t.request_price_guid='{requestPriceGuid}' and t.del_flag='0'
group by t.status,t.plate_norder,t.plate_formal_alias,t.plate_formal_guid,t.request_price_guid