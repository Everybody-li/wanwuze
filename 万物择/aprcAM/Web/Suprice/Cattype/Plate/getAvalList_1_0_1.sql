-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-板块配置-查询可添加的板块列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询当前品类未添加的板块列表
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate t1,coz_model_fixed_data t2
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;业务guid：品类型号guid或品类guid，有型号guid传型号guid，没有则传品类guid
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output fixedDataCodeGuid string[36] 固化字段名称guid;固化字段名称guid
-- ##output fixedDataCode char[36] 固化字段名称;固化字段名称
-- ##output fixedDataName string[20] 固化字段名称;固化字段名称

select
t1.guid as fixedDataCodeGuid
,t1.code as fixedDataCode
,t1.name as fixedDataName
from
coz_model_fixed_data t1
where 
t1.del_flag='0' and t1.type='1' 
and t1.biz_type=(case when('{bizType}'='1' or '{bizType}'='3') then '2' when ('{bizType}'='2') then '1' else '1' end)
and not exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate where biz_guid='{bizGuid}' and del_flag='0' and fixed_data_code=t1.guid)
order by t1.id