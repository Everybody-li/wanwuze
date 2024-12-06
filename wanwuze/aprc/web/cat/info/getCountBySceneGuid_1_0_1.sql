-- ##Title web-根据需求场景使用默认图片的查询品类信息数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-根据需求场景使用默认图片的查询品类信息数量
-- ##CallType[QueryData]

-- ##input sceneGuid char[36] NOTNULL;末级场景guid，必填
-- ##input categoryName string[50] NULL;字节内容名称，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
count(1) as categoryNum
from
coz_category_info t1
inner join
coz_category_supplydemand t2
on t2.category_guid=t1.guid
where 
t2.scene_tree_guid='{sceneGuid}' and t1.del_flag='0'  and t2.del_flag='0' and (t1.name like '%{categoryName}%' or '{categoryName}'='') and t1.img_upd_flag='0'
