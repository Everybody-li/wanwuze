-- 目录：aprcAM\PluginServe\Suprice\Cattype\Price\getPlFieldContFormalList_1_0_1
-- ##Title 插件端-web后台-审批模式-通用配置-供应报价信息管理-发布逻辑-查询已发布的字段内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 查询当前品类已发布的字段内容列表，只查自建内容库
-- ##Describe 表名：coz_model_am_suprice_plate_field_content_formal t4
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

select
t.plate_field_guid as plateFieldGuid
,t.name as plateFieldContent
from
coz_model_am_suprice_plate_field_content_formal t
where 
t.category_guid='{categoryGuid}' and t.del_flag='0'
order by t.norder
