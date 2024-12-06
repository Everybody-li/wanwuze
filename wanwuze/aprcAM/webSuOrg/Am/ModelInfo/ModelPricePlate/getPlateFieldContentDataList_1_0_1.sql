-- ##Title  web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-创建型号产品介绍-查询字段名称下的字段内容列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##Describe 表名：coz_model_am_aprom_plate_field_content_formal t1 coz_model_fixed_data t2,coz_model_fixed_data_value t3,coz_model_am_aprom_plate_field_formal t4
-- ##Describe 排序：字段名称的顺序升序
-- ##CallType[QueryData]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input content string[50] NULL;字段内容，非必填
-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置

-- ##output plateFieldContentGuid char[36] 字段内容guid;字段内容guid
-- ##output content string[50] 字段内容;
-- ##output valueGuid char[36] 板块字段内容候选项guid;板块字段内容候选项guid

select
*
from
(
select
t.guid as plateFieldContentGuid
,t.name as content
,t.norder
,'' as valueGuid
from
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field_content_formal t
where 
t.plate_field_guid='{plateFieldGuid}' and t.del_flag='0' and (t.name like '%{content}%' or '{content}'='')
union all
select 
t3.guid as plateFieldContentGuid
,t3.value as content
,t4.norder
,t3.guid as valueGuid
from 
coz_model_fixed_data t2
inner join 
coz_model_fixed_data_value t3
on t2.guid = t3.fixed_data_guid
inner join 
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field_formal t4
on t2.guid = t4.content_fixed_data_guid 
where t4.guid = '{plateFieldGuid}' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and (t3.value like '%{content}%' or '{content}'='')
)t
order by t.norder