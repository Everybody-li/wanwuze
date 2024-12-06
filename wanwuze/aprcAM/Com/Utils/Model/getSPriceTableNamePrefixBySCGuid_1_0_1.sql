-- ##Title 服务共用方法-工具栏-获取表名前缀-型号专员交易模式/审批模式-查询供应报价信息表名前缀（前端忽略）
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询 根据末级场景guid获取供应报价信息业务对应的表名前缀
-- ##CallType[QueryData]

-- ##input secenGuid string[36] NOTNULL;末级场景guid

-- ##output tableNamePrefix string[100] 表名前缀;表名前缀：1-coz_model_am_suprice，2-coz_model_am_modelprice_de，3-coz_model_am_modelprice_sp


select case
           when t3.mode = 2 then 'coz_category_supply_price'
           when t3.mode = 3 then 'coz_category_am_suprice'
           else 'coz_category_am_suprice' end as tableNamePrefix
from coz_category_scene_tree t1
         inner join coz_cattype_sd_path t2 on t1.sd_path_guid = t2.guid
         inner join coz_cattype_fixed_data t3 on t2.cattype_guid = t3.guid
where t1.guid = '{secenGuid}';
