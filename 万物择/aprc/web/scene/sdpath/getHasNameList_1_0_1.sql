-- ##Title web-查询服务名称选择列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务名称选择列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.guid as sdPathGuid
,t1.name as sdPName
from 
coz_cattype_sd_path t1
where t1.name<>'' and del_flag='0'
order by t1.norder desc