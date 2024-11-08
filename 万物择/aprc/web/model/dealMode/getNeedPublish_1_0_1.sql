-- ##Title web-查询需要一起发布的供需需求信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询需要一起发布的供需需求信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid char[36] 品类guid，必填;品类guid，必填


select
t.category_guid as category_guid
from
coz_category_deal_mode t
where 
cattype_guid='{categoryGuid}' and category_guid<>cattype_guid and not exists(select 1 from coz_category_deal_mode_log where t.category_guid=category_guid and del_flag='0') and t.del_flag='0'
