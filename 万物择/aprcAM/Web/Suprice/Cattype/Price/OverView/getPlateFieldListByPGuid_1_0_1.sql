-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-信息格式排序-查询板块下的字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate_field t1,表名前缀_plate_field_content t2
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input plateGuid char[36] NOTNULL;板块guid
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分：demand-采购需求，supply-供应需求
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateFieldGuid string[36] 板块字段名称guid;板块字段名称guid
-- ##output plateFieldName string[1] 板块字段名称;板块字段名称
-- ##output plateFieldAlias string[36] 板块字段别名;板块字段别名
-- ##output norder int[>=0] 1;顺序

select
t.guid as plateFieldGuid
,case when(t.source=2) then t.alias else (select name from coz_model_fixed_data where guid=t.name) end as plateFieldName
,t.alias as plateFieldAlias
,t.norder
from
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field t
where
t.plate_guid='{plateGuid}' and t.del_flag='0'
order by t.norder