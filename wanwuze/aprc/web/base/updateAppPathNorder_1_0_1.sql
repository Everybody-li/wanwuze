-- ##Title web-新增采购路径名称
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-新增采购路径名称
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;订单退货guid，必填
-- ##input pathType string[6] NOTNULL;主体类型（1：个人，2：企业），必填
-- ##input oldNorder int[>=0] NOTNULL;路径名称，必填
-- ##input newNorder int[>=0] NOTNULL;路径名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @parentGuid=(select parent_guid coz_cattype_demand_path where guid='{guid}')
;
update coz_cattype_demand_path
set app_norder='{oldNorder}'
,update_by='{curUserId}'
,update_time=now()
where guid='{guid}' and parent_guid=@parentGuid and app_norder='{newNorder}' and '{pathType}'='demand'
;
update coz_cattype_demand_path
set app_norder='{newNorder}'
,update_by='{curUserId}'
,update_time=now()
where guid='{guid}' and '{pathType}'='demand'
;

update coz_cattype_supply_path
set app_norder='{oldNorder}'
,update_by='{curUserId}'
,update_time=now()
where guid='{guid}' and parent_guid=@parentGuid and app_norder='{newNorder}' and '{pathType}'='supply'
;
update coz_cattype_supply_path
set app_norder='{newNorder}'
,update_by='{curUserId}'
,update_time=now()
where guid='{guid}' and '{pathType}'='supply'
;