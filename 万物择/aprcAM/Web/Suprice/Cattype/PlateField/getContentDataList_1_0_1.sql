-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-供应报价信息配置-字段名称配置-字段内容配置-字段内容管理-查询内容数据列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询，
-- ##Describe 表名前缀获取：aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1
-- ##Describe 表名：表名前缀_plate_field_content t1,表名前缀_plate_field t2
-- ##CallType[QueryData]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateContentGuid char[36] 字段内容guid;
-- ##output plateContentName string[20] 字段内容;


PREPARE q1 FROM '
select
t.guid as plateContentGuid
,t.name as plateContentName
-- ,t.relate_field_guid as relateFieldGuid
-- ,case when(t1.source=2) then t1.name else (select name from coz_model_fixed_data where guid=t1.name) end as plateFieldName
from
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field_content t
-- left join
-- {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field t1
-- on t.relate_field_guid=t1.guid
where 
t.plate_field_guid=''{plateFieldGuid}'' and t.del_flag=''0''
order by t.norder
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
