-- ##Title 服务共用方法-工具栏-获取表名前缀-型号专员交易模式/审批模式-查询供应报价信息表名前缀（前端忽略）
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询 根据品类类型获取供应报价信息业务对应的表名前缀
-- ##CallType[QueryData]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid

-- ##output tableNamePrefix string[100] 表名前缀;表名前缀：1-coz_model_am_suprice，2-coz_model_am_modelprice_de，3-coz_model_am_modelprice_sp

select case
           when mode = 2 then 'coz_category_supply_price'
           when mode = 3 then 'coz_category_am_suprice'
           else 'coz_category_am_suprice' end as tableNamePrefix
from coz_cattype_fixed_data
where guid = '{cattypeGuid}';