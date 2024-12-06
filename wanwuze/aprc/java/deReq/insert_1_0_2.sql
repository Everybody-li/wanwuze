-- ##Title insertDeReqAndPlateT
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-新增需求及需求范围内容
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;需求guid，必填
-- ##input parentGuid string[36] NULL;父需求guid，非必填
-- ##input parentRequestPriceGuid string[36] NULL;物流需求组成部分包含父需求供方报价信息，非必填
-- ##input supplyAssignRuleType string[50] NULL;子(物流)需求供方指派规则，非必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径全节点名称guid，必填
-- ##input sdPathAllName string[100] NOTNULL;采购供应路径全节点名称，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input cattypeName string[50] NOTNULL;品类类型名称，必填
-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input categoryName string[500] NOTNULL;品类名称，必填
-- ##input categoryAlias string[500] NULL;品类名称别名，非必填
-- ##input categoryTime string[30] NOTNULL;品类创建时间，必填
-- ##input priceMode string[1] NOTNULL;品类报价模式，必填
-- ##input serveFeeFlag string[1] NOTNULL;收取服务费（0-免费，1：收费），必填
-- ##input dealRuleLogGuid string[36] NOTNULL;交易规则日志guid，必填
-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input userName string[36] NOTNULL;用户名称，必填
-- ##input userPhone string[15] NOTNULL;用户手机号，必填
-- ##input longitude string[50] NULL;需方提需求时经度，非必填
-- ##input latitude string[50] NULL;需方提需求时纬度，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input needDeliverFlag string[1] NOTNULL;品类报价模式，必填


insert into coz_demand_request(guid,parent_guid,parent_request_price_guid,supply_assign_rule_type,all_parent_id,sd_path_guid,sd_path_all_name,cattype_guid,cattype_name,category_guid,category_name,category_img,category_alias,category_time,price_mode,serve_fee_flag,deal_rule_log_guid,user_id,user_name,user_phone,longitude,latitude,need_deliver_flag,del_flag,create_by,create_time,update_by,update_time)
select
'{guid}' as guid
,'{parentGuid}' as parentGuid
,'{parentRequestPriceGuid}' as parent_request_price_guid
,'{supplyAssignRuleType}' as supply_assign_rule_type
,(select CONCAT(ifnull(all_parent_id,''),',',id) from coz_demand_request where guid='{parentGuid}') as allpar
,'{sdPathGuid}' as sdPathGuid
,'{sdPathAllName}' as sdPathAllName
,'{cattypeGuid}' as cattypeGuid
,'{cattypeName}' as cattypeName
,'{categoryGuid}' as categoryGuid
,'{categoryName}' as categoryName
,t.img
,'{categoryAlias}' as categoryAlias
,'{categoryTime}' as categoryTime
,'{priceMode}' as priceMode
,'{serveFeeFlag}' as severFeeFlag
,'{dealRuleLogGuid}' as dealRuleLogGuid
,'{userId}' as userId
,'{userName}' as userName
,'{userPhone}' as userPhone
,'{longitude}' as longitude
,'{latitude}' as latitude
,'{needDeliverFlag}' as needDeliverFlag
,0 as del_flag
,'1' as create_by
,now() as create_time
,'1' as update_by
,now() as update_time
from
coz_category_info t
where guid='{categoryGuid}'
;
insert into coz_demand_request_serve2_source(guid,request_guid,aprice_uc_guid,aprice_staff_user_id,request_time)
select
uuid()
,'{guid}'
,guid
,user_id
,now()
from
coz_server2_sys_user_category
where 
category_guid='{categoryGuid}' and del_flag='0'