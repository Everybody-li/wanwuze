-- ##Title web-根据需求场景查询品类信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-根据需求场景查询品类信息
-- ##CallType[QueryData]

-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填

select
t.cattype_guid as cattypeGuid
,t.guid as categoryGuid
,t.name as categoryName
,t.cattype_name as cattypeName
from
coz_category_info t
left join
coz_category_supplydemand t1
on t1.category_guid=t.guid
where 
t.del_flag='0' and t1.scene_tree_guid='{secenGuid}'	

