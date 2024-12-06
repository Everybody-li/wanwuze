-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购/供应需求信息配置-字段名称配置-字段内容配置-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询，
-- ##Describe 出参“字段内容来源设置”逻辑：t2.content_source=0，则未设置，否则是已配置
-- ##Describe 出参“需方操作设置”逻辑：t2.operation=0，则未设置，否则是已配置
-- ##Describe 出参“字段内容管理”逻辑：(t2.content_source=0) 或 (t2.content_source=1,t2.content_fixed_data_guid is null)或 (t2.content_source=2,t3子数据无数据)，则未配置，否则是已配置
-- ##Describe 表名：coz_model_am_aprom_plate_field t1,coz_model_am_aprom_plate_field_settings t2,coz_model_am_aprom_plate_field_content t3
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分：demand-采购需求，supply-供应需求
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateFieldGuid char[36] 板块字段名称guid;板块字段名称guid
-- ##output plateFieldName string[20] 板块字段名称;板块字段名称
-- ##output fieldContentSource string[1] 1;字段内容来源：1-字段内容固化库，2-字段内容自建库，3-需方，4-供方
-- ##output operation string[1] 1;供/需方操作设置：0-未设置，1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##output contentSetFlag string[1] 1;字段内容管理是否设置(0：未设置，1：已设置)
-- ##output placeholder string[200] 供/需方操作提示信息;供/需方操作提示信息
-- ##output catTreeCode string[50] supply;采购还是供应（supply：供应，demand：采购）
-- ##output fileTemplate string[200] 文件/图片模板;文件/图片模板
-- ##output contentFixedDataGuid char[36] 固化字段内容guid;固化字段内容guid
-- ##output contentFixedDataName string[20] 固化字段内容名称;固化字段内容名称

select
t.guid as plateFieldGuid
,'{catTreeCode}' as catTreeCode
,case when(t.source=2) then t.alias else (select name from coz_model_fixed_data where guid=t.name) end as plateFieldName
,case when(t1.guid is null) then '0' else t1.content_source end as fieldContentSource
,case when(t1.guid is null) then '0' else t1.operation end as operation
,t1.placeholder
,t1.file_template as fileTemplate
,case when(t1.guid is null) then '0' when (t1.content_source ='0') then '0' when (t1.content_source ='1' and (t.content_fixed_data_guid is null or t.content_fixed_data_guid='')) then '0' when ((t1.content_source ='2') and not exists(select 1 from coz_model_am_aprom_plate_field_content where plate_field_guid=t.guid and del_flag='0')) then '0' else '1' end as contentSetFlag
,t.content_fixed_data_guid as contentFixedDataGuid
,(select name from coz_model_fixed_data where guid=t.content_fixed_data_guid) as contentFixedDataName
from
coz_model_am_aprom_plate_field t
left join
coz_model_am_aprom_plate_field_settings t1
on t1.plate_field_guid=t.guid and t1.cat_tree_code='{catTreeCode}'
where 
t.guid='{plateFieldGuid}' and t.del_flag='0'
order by t.norder