-- ##Title 查询国家列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询省列表
-- ##CallType[QueryData]

-- ##input allParentId string[100] NULL;已选中的区域组系节点id（1个），非必填
-- ##input parentCode string[11] NOTNULL;父级code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
guid
,case when('{allParentId}'='0') then '2' when((all_parent_id like '%{allParentId}%' or '{allParentId}' like concat('%',all_parent_id,'%')) and '{allParentId}'<>'') then '1' else '0' end as selectedFlag
,code
,id
,parent_code as parentCode
,all_parent_id as allParentId
,path_name as pathName
,level
,name
from sys_city_code t
where t.level=0 and version=1 and parent_code='{parentCode}'
order by id
