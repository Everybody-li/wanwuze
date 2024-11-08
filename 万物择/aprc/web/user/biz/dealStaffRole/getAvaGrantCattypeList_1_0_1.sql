-- ##Title web-交易专员-查询可设置的品类类型列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易专员-查询可设置的品类类型列表
-- ##CallType[QueryData]

-- ##input roleKey string[50] NULL;目标用户角色类型，必填
-- ##input userId string[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t2.guid as cattypeGuid
,t2.name as cattypeName
,case when exists(select 1 from coz_server2_sys_user_cattype where cattype_guid=t2.guid and del_flag='0' and user_id='{userId}' and role_key='{roleKey}') then '1' else '0' end as selectedFlag
from 
coz_cattype_fixed_data t2
where 
t2.del_flag='0'
order by t2.norder desc
