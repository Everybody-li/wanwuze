-- ##Title app-采购-查看需求内容详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-按单-查询供方需求范围内容
-- ##CallType[QueryData]

-- ##input requestGuid string[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.status
,'1' as bizType
,t.plate_norder as norder
,t.plate_formal_alias as alias
,t.plate_formal_guid as plateGuid
,CONCAT('{ChildRows_aprc\\web\\order\\detail\\dReqPlates\\getPlateFields_1_0_1:plateGuid=''',t.plate_formal_guid,'''}') as `field`
from
coz_demand_request_plate t
where
t.request_guid='{requestGuid}' and t.del_flag='0'
group by t.status,t.plate_norder,t.plate_formal_alias,t.plate_formal_guid