-- ##Title 查询县/区列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询县/区列表
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
where t.level=3 and version=1 and parent_code='{parentCode}'
order by id
