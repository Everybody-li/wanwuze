-- ##Title 品类-根据末级场景guid获取详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 品类-根据末级场景guid获取详情
-- ##CallType[QueryData]

-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填


select
    t1.guid,
    t1.name,
    t1.parent_guid parentGuid,
    t1.sd_path_guid sdPathGuid,
    t3.guid cattypeGuid,
    t3.name cattypeName,
    t3.mode cattypeMode,
    t4.login_code as loginCode
from coz_category_scene_tree t1
         inner join coz_cattype_sd_path t2 on t1.sd_path_guid = t2.guid
         inner join coz_cattype_fixed_data t3 on t2.cattype_guid = t3.guid
         left join coz_cattype_supply_path_lgcode t4 on t4.supply_path_guid = t2.supply_path_guid
where t1.del_flag = '0' and t2.del_flag = '0' and t3.del_flag = '0'
  and t1.guid = '{secenGuid}'