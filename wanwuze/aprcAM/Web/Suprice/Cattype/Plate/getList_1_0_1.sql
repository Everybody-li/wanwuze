-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-板块配置-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate t1,coz_model_fixed_data t2
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid或品类类型guid/品类guid，有型号guid传型号guid，没有则传品类类型guid/品类guid
-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output categoryGuid char[36] 品类类型guid/品类guid;
-- ##output plateGuid char[36] 板块guid;
-- ##output plateName string[50] 板块名称;板块名称
-- ##output plateAlias string[50] 板块别名;板块别名
-- ##output fixedDataCode char[36] 板块固化字段名称guid;板块固化字段名称guid
-- ##output norder int[>=0] 1;板块顺序
-- ##output hasSon int[>=0] 0;是否还有儿子节点（0：否，1-是）

select
t.category_guid as categoryGuid
,t.guid as plateGuid
,concat(t1.name,'(',t.alias,')') as plateName
,t.alias as plateAlias
,t.fixed_data_code as fixedDataCode
,t.norder
,case when exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field where plate_guid=t.guid and del_flag='0') then '1' else '0' end as hasSon
from
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate t
inner join
coz_model_fixed_data t1
on t.fixed_data_code=t1.guid
where
t.biz_guid='{bizGuid}' and t.del_flag='0' and t1.del_flag='0'
order by t.norder