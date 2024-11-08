-- ##Title 运营经理-渠道选拔管理-根据品类模式统计每个供应管理系统下的供方数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 统计t1的数量,按t5.guid,t1.guid分组统计
-- ##Describe 表名:表名:coz_category_supplier t1,coz_category_info t2,coz_category_supplydemand t3,coz_category_scene_tree t4,coz_cattype_sd_path t5,coz_org_info t6
-- ##CallType[QueryData]


-- ##input mode enum[2,3] NOTNULL;品类模式：2-交易模式，3-审批模式

-- ##output lgCount int[>=0] 1;数量
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output supplyLgCodeGuid char[36] 供方登录系统guid;供方登录系统guid
-- ##output sdPathGuid char[36] ;采购供应路径guid


-- select
-- t.login_sysname as supplySystem
-- ,ifnull(t1.lgCount,0) as lgCount
-- ,t.guid as supplyLgCodeGuid
-- from
-- coz_lgcode_fixed_data t
-- left join
-- (
-- select t1.guid            as sdPathGuid
--      , t1.lgcode_guid     as supplyLgCodeGuid
--      , lgfd.login_sysname as supplySystem
--      , count(1)           as lgCount
-- from coz_cattype_sd_path t1
--          inner join coz_org_info_lgcode orglg on t1.lgcode_guid = orglg.lgcode_guid
--          inner join coz_org_info org on org.user_id = orglg.user_id
--          inner join coz_lgcode_fixed_data lgfd on lgfd.guid = orglg.lgcode_guid
--          inner join coz_cattype_fixed_data fixdata on t1.cattype_guid = fixdata.guid
-- where t1.del_flag = '0'
--   and orglg.del_flag = '0'
--   and org.del_flag = '0'
--   and fixdata.mode = {mode}
-- group by t1.lgcode_guid, lgfd.login_sysname
-- )t1
-- on t.guid=t1.supplyLgCodeGuid

select t1.guid            as sdPathGuid
     , t1.lgcode_guid     as supplyLgCodeGuid
     , lgfd.login_sysname as supplySystem
     , count(1)           as lgCount
from coz_cattype_fixed_data fixdata
         left join coz_cattype_sd_path t1 on t1.cattype_guid = fixdata.guid
         left join coz_org_info_lgcode orglg on t1.lgcode_guid = orglg.lgcode_guid
         left join coz_org_info org on org.user_id = orglg.user_id
         left join coz_lgcode_fixed_data lgfd on lgfd.guid = orglg.lgcode_guid
where t1.del_flag = '0'
  and fixdata.mode = {mode}
group by t1.lgcode_guid, lgfd.login_sysname
order by t1.norder;




