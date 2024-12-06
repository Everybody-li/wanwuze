-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询，字段内容配置情况逻辑：该字段名称未添加字段内容(包括固化库和自建库)或未设置字段操作类型，则未配置，否则是已配置
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate t1,_field t1,表名前缀_plate_field_content t2
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid或品类类型guid/品类guid，有型号guid传型号guid，没有则传品类类型guid/品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output categoryGuid char[36] 品类guid;
-- ##output plateGuid char[36] 板块guid;
-- ##output plateFieldGuid char[36] 板块字段名称guid;
-- ##output plateFieldName string[20] 板块字段名称;板块字段名称
-- ##output plateFieldAlias string[20] 板块字段别名;板块字段别名
-- ##output plateName string[20] 关联的板块名称;
-- ##output contOpFlag string[20] 1;字段内容配置情况(0-未配置 ，1-已配置)

select
t.guid as plateFieldGuid
,case when(t.source=2) then t.alias else (select name from coz_model_fixed_data where guid=t.name) end as plateFieldName
,t.alias as plateFieldAlias
,t1.guid as plateGuid
,concat(t2.name,'(',t1.alias,')') as plateName
,t.category_guid as categoryGuid
,(select code from coz_model_fixed_data where guid=t.name) as plateFieldCode
,t1.alias as plateAlias
,t.source
,case when (t.content_source ='0' or t.operation ='0') then '0' when (t.content_source ='1' and (t.content_fixed_data_guid is null or t.content_fixed_data_guid='')) then '0' when ((t.content_source ='2') and not exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field_content where plate_field_guid=t.guid and del_flag='0')) then '0' else '1' end as contOpFlag
from
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field t
left join
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate t1
on t.plate_guid=t1.guid
left join
coz_model_fixed_data t2
on t1.fixed_data_code=t2.guid and t2.del_flag='0'
where 
 t.biz_guid='{bizGuid}'  and t.del_flag='0'
order by t.norder