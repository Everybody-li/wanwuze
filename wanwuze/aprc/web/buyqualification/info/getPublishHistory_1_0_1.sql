-- ##Title web-查询供需需求信息发布记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供需需求信息发布记录
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


-- ##output publishTime String[19] 发布时间;发布时间（格式：0000年00月00日 00:00）

select
concat(left(t.publish_time,4),'年',right(left(t.publish_time,7),2),'月',right(left(t.publish_time,10),2),'日',right(left(t.publish_time,16),6)) as publishTime
from
coz_category_buy_qualification_log t where t.category_guid='{categoryGuid}'
order by t.publish_time desc