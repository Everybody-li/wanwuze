-- ##Title web-查询品类类型信息-沟通类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类类型信息-沟通类
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select
t1.guid as cattypeGuid
,t1.name as cattypeName
,(select count(1) from coz_category_info where cattype_guid=t1.guid and del_flag='0') as categoryNum
from
coz_cattype_fixed_data t1
where
t1.mode='1' and t1.del_flag='0'
order by t1.norder
