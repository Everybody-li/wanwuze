-- ##Title web-查询服务对象投放记录列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询服务对象投放记录列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填

select
left(create_time,16) as operaTime
,real_num as realNum
from
coz_serve_tbuser_free t1
where
t1.del_flag='0' and t1.cattype_guid='{cattypeGuid}'
order by t1.id desc
