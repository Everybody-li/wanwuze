-- ##Title web-有选中状态-获取村委会列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-有选中状态-获取村委会列表_1_0_1
-- ##CallType[QueryData]

-- ##input parentCode string[11] NOTNULL;父级code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
guid
,case when('{allParentId}'=all_parent_id) then '2' when((all_parent_id like '%{allParentId}%' or '{allParentId}' like concat('%',all_parent_id,'%')) and '{allParentId}'<>'') then '1' else '0' end as selectedFlag
,code
,id
,parent_code as parentCode
,all_parent_id as allParentId
,path_name as pathName
,level
,name
from sys_city_code t
where t.level=5 and version=1 and parent_code='{parentCode}'
order by id
