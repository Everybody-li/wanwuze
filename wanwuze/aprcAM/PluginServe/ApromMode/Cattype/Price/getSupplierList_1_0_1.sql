-- ##Title 插件端-web后台-审批模式-通用配置-供应报价信息管理-发布逻辑-查询供方列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 查询：
-- ##Describe 表名：coz_category_supplier_am_model
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output supplierGuid char[36] 供方品类guid;供方品类guid


select
t.guid as supplierGuid
from
coz_category_supplier t
where 
t.category_guid='{categoryGuid}' and t.del_flag='0'
order by t.id
