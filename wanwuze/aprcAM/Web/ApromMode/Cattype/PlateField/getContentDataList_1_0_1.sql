-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购/供应需求信息配置-字段名称配置-字段内容配置-字段内容管理-查询内容数据列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询，
-- ##Describe 表名：coz_model_am_aprom_plate_field_content t1,coz_model_am_aprom_plate_field t2
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateContentGuid char[36] 字段内容guid;字段内容guid
-- ##output plateContentName string[20] 字段内容;字段内容
-- ##output plateFieldName string[20] 关联的字段名称;关联的字段名称
-- ##output relateFieldGuid char[36] 关联的字段名称guid;关联的字段名称guid：前端，该字段有值，则显示”解除关联字段名称“，否则显示“关联字段名称“

PREPARE q1 FROM '
select
t.guid as plateContentGuid
,t.name as plateContentName
,t.relate_field_guid as relateFieldGuid
,case when(t1.source=2) then t1.name else (select name from coz_model_fixed_data where guid=t1.name) end as plateFieldName
from
coz_model_am_aprom_plate_field_content t
left join
coz_model_am_aprom_plate_field t1
on t.relate_field_guid=t1.guid
where 
t.plate_field_guid=''{plateFieldGuid}'' and t.del_flag=''0''
order by t.norder
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
