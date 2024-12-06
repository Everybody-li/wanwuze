-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-查询业务主表表名（前端忽略）
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询 根据业务菜单类型获取业务对应的表名前缀
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式的供应报价配置管理，2/3-审批报价配置管理

-- ##output tableName string[100] coz_category_am_suprice;业务主表表名：1-coz_category_am_suprice，2/3-coz_category_am_modelprice


select case
    when '{bizType}' = 1 then 'coz_category_am_suprice'
    when '{bizType}' = 2 then 'coz_category_am_modelprice'
    when '{bizType}' = 3 then 'coz_category_am_modelprice'
else 'coz_category_am_suprice' end as tableName
;