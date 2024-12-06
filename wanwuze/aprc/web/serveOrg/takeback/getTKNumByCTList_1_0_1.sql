-- ##Title app-查询服务业绩统计的月份详情列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-查询服务业绩统计的月份详情列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
t1.guid as cattypeGuid
,t1.name as cattypeName
,(select count(1) from coz_serve_org_gain_log where cattype_guid=t1.guid and del_flag='0' and takeback_flag='1' and free_flag='0') as takebackNum
from
coz_cattype_fixed_data t1
where
t1.del_flag='0'
order by t1.norder
