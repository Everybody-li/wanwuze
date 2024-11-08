-- ##Title 插件端-web后台-审批模式-通用配置-供需需求信息管理-发布逻辑-查询已发布的字段内容不是上传文件或需方填写的字段内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe 查询当前品类已发布的字段内容列表，只查自建内容库
-- ##Describe 表名：coz_model_am_aprom_plate_field_content_formal t4
-- ##CallType[QueryData]


select
t.plate_field_guid as plateFieldGuid
,t.name as plateFieldContent
,t.relate_field_guid as relateFieldGuid
from
coz_model_am_aprom_plate_field_content_formal t
where 
t.category_guid='{categoryGuid}' and t.del_flag='0'
order by t.norder
