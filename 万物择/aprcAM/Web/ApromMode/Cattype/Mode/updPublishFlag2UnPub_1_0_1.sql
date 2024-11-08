-- ##Title web后台-审批模式-通用配置-供需需求信息管理-将发布标志改为未发布
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web后台-审批模式-通用配置-供需需求信息管理-将发布标志改为未发布
-- ##Describe 服务端调用，前端忽略
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_am_aprom_mode
set publish_flag='0'
where category_guid='{categoryGuid}'
;
