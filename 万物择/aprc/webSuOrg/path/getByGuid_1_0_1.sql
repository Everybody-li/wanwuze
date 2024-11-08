-- ##Title web-根据供应路劲guid查询供应路径信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-根据供应路劲guid查询供应路径信息
-- ##CallType[QueryData]

-- ##input supplyPathGuid string[36] NOTNULL;供应路劲guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.cattype_guid as cattypeGuid
,t2.guid as sdPathGuid
,t1.norder
,t1.guid as pathGuid
,t1.name as pathName
,t1.all_path_name as treeTitleString1
,t1.icon
,t3.mode
from
coz_cattype_supply_path t1
inner join
coz_cattype_sd_path t2
on t2.supply_path_guid=t1.guid
inner join
coz_cattype_fixed_data t3
on t2.cattype_guid=t3.guid
where  t1.guid='{supplyPathGuid}'
order by t1.norder
