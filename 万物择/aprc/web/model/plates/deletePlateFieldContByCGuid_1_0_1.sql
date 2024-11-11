-- ##Title web-根据品类guid清空字段内容（固化库/自建库）
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-根据品类guid清空字段内容（固化库/自建库）
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类名称Guid，必填
-- ##input bizType string[1] NOTNULL;业务类型：1-供需需求信息配置，2-供应报价信息配置， 4-采购资质信息配置，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_category_deal_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where '{bizType}' = 1 and category_guid = '{categoryGuid}';

update coz_category_supply_price
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where '{bizType}' = 2  and category_guid = '{categoryGuid}';


update coz_model_plate_field_content
set publish_flag='0'
,del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where category_guid='{categoryGuid}' and biz_type='{bizType}'
;
update coz_model_plate
set publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where category_guid='{categoryGuid}' and biz_type='{bizType}'
;