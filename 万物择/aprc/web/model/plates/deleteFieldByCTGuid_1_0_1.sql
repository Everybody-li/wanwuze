-- ##Title web-通用配置-根据品类名称guid清空字段名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-通用配置-根据品类名称guid清空字段名称
-- ##CallType[ExSql]

-- ##input catTreeCode enum[demand,supply] NOTNULL;供需采购类型，必填
-- ##input categoryGuid char[36] NOTNULL;品类名称Guid，必填
-- ##input bizType string[1] NOTNULL;业务类型：1-供需需求信息配置，2-供应报价信息配置， 4-采购资质信息配置，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_model_plate_field_content
set publish_flag='0'
,del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where cat_tree_code = '{catTreeCode}' and category_guid='{categoryGuid}' and biz_type='{bizType}'
;
update coz_model_plate_field
set publish_flag='0'
,del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where cat_tree_code = '{catTreeCode}' and  category_guid='{categoryGuid}' and biz_type='{bizType}'
;