-- ##Title web-查询服务费设置详情-按品类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务费设置详情-按品类
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output ratio int[>=0] 1;收费比例
-- ##output type int[>=0] 1;收取范围（1：按品类，2：按供方型号，3：按我方型号；此接口为”按品类”查询详情接口，前端可在页面写死“按品类”）
-- ##output targetObject string[20] demand;收取对象（demand：需方，supply：供方）

select
charge_value
,charge_type
,target_object as targetObject
from
coz_category_service_fee
where 
category_guid='{categoryGuid}' and charge_type='1' and del_flag='0'