-- ##Title web-查询品类类型信息-交易类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类类型信息-交易类
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填



select
cfd.guid as cattypeGuid
,cfd.name as cattypeName
,(select count(distinct t1.id) from coz_category_info  t1
                    inner join coz_category_supplydemand t3 on t1.guid = t3.category_guid
                    inner join coz_category_scene_tree t4 on t3.scene_tree_guid = t4.guid
           where t1.del_flag = '0' and t3.del_flag = '0' and t4.del_flag = '0' and t1.cattype_guid=cfd.guid ) as categoryNum
from
coz_cattype_fixed_data cfd
where
cfd.mode='2' and cfd.del_flag='0'
order by cfd.norder

