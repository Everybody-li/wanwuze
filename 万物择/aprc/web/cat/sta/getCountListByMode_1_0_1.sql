-- ##Title web-查询品类类型信息-审批模式/交易模式/沟通模式
-- ##Author 卢文彪
-- ##CreateTime 2023-08-19
-- ##Describe web-查询品类类型信息-审批模式/交易模式/沟通模式
-- ##CallType[QueryData]

-- ##input mode enum[1,2,3] NOTNULL;品类模式：1-沟通模式，2-交易模式，3-审批模式
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select
t1.guid as cattypeGuid
,t1.name as cattypeName
,(select count(1) from coz_category_info where cattype_guid=t1.guid and del_flag='0') as categoryNum
from
coz_cattype_fixed_data t1
where
t1.mode={mode} and t1.del_flag='0'
order by t1.norder
