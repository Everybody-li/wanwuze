-- ##Title app-供应-查询接收设置信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询接收设置信息
-- ##CallType[QueryData]

-- ##input supplyPathGuid char[36] NOTNULL;供应路径guid，必填
-- ##input categoryGuid char[36] NOTNULL;供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
(select count(1) from coz_demand_request_match_notice a inner join coz_demand_request b on a.request_guid=b.guid where a.supply_path_guid='{supplyPathGuid}' and a.user_id='{curUserId}' and a.recommend_type='1' and a.del_flag='0' and b.category_guid='{categoryGuid}') as rt1Count
,(select count(1) from coz_demand_request_match_notice a inner join coz_demand_request b on a.request_guid=b.guid where a.supply_path_guid='{supplyPathGuid}' and a.user_id='{curUserId}' and a.recommend_type='2' and a.del_flag='0' and b.category_guid='{categoryGuid}') as rt2Count