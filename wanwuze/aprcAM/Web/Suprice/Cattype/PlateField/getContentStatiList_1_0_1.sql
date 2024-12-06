-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-字段内容配置-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询，
-- ##Describe 出参“字段内容来源设置”逻辑：t1.content_source=0，则未设置，否则是已配置
-- ##Describe 出参“供/需方操作设置”逻辑：t1.operation=0，则未设置，否则是已配置
-- ##Describe 出参“字段内容管理”逻辑：(t1.content_source=0) 或 (t1.content_source=1,t1.content_fixed_data_guid is null)或 (t2.content_source=1,t2子数据无数据)，则未配置，否则是已配置
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate_field t1,表名前缀_plate_field_content t2
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateFieldGuid char[36] 板块字段名称guid;
-- ##output plateFieldName string[20] 板块字段名称;
-- ##output fieldContentSource string[1] 1;字段内容来源：1-字段内容固化库，2-字段内容自建库，3-需方，4-供方
-- ##output operation string[1] 1;供/需方操作设置：0-未设置，1-单选框，2-复选框，3-填写文本框，4-图片上传，5-文档上传
-- ##output contentSetFlag string[1] 1;字段内容管理是否设置(0：未设置，1：已设置)
-- ##output placeholder string[200] 供/需方操作提示信息;供/需方操作提示信息
-- ##output fileTemplate string[200] 文件/图片模板;文件/图片模板
-- ##output contentFixedDataGuid char[36] 固化字段内容guid;固化字段内容guid 
-- ##output contentFixedDataName string[20] 固化字段内容名称;固化字段内容名称 

select
t.guid as plateFieldGuid
,case when(t.source=2) then t.alias else (select name from coz_model_fixed_data where guid=t.name) end as plateFieldName
,t.content_source as fieldContentSource
,t.operation as operation
,t.placeholder
,case when (t.content_source ='0') then '0' when (t.content_source ='1' and (t.content_fixed_data_guid is null or t.content_fixed_data_guid='')) then '0' when ((t.content_source ='2') and not exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field_content where plate_field_guid=t.guid and del_flag='0')) then '0' else '1' end as contentSetFlag
,t.file_template as fileTemplate
,t.content_fixed_data_guid as contentFixedDataGuid
,t1.name as contentFixedDataName
from
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field t
left join
coz_model_fixed_data t1
on t.content_fixed_data_guid=t1.guid
where 
t.guid='{plateFieldGuid}' and t.del_flag='0'
order by t.norder