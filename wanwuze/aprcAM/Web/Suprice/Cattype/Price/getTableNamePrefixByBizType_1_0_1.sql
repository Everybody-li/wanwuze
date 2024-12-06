-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-查询板块相关表名前缀（前端忽略）
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询 根据业务菜单类型获取业务对应的表名前缀
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置

-- ##output tableNamePrefix string[100] 表名前缀;表名前缀：1-coz_model_am_suprice，2-coz_model_am_modelprice_de，3-coz_model_am_modelprice_sp

select case
    when '{bizType}' = 1 then 'coz_model_am_suprice'
    when '{bizType}' = 2 then 'coz_model_am_modelprice_de'
    when '{bizType}' = 3 then 'coz_model_am_modelprice_sp'
else 'coz_model_am_suprice' end as tableNamePrefix
;