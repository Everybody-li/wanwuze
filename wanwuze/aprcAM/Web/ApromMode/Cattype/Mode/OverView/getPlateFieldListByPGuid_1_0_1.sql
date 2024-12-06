-- ##Title web后台-审批模式-通用配置-供需需求信息管理-信息格式排序-查询板块下的一级字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 出参”是否有字段内容关联字段名称“逻辑：字段名称的有自建内容且关联了字段名称，则为是，否则为否
-- ##Describe 表名：coz_model_am_aprom_plate_field t1,coz_model_am_aprom_plate_field_settings t2,coz_model_am_aprom_plate_field_content t3
-- ##CallType[QueryData]

-- ##input plateGuid char[36] NOTNULL;板块guid
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分：demand-采购需求，supply-供应需求
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output plateFieldGuid string[36] 板块字段名称guid;板块字段名称guid
-- ##output plateFieldName string[1] 板块字段名称;板块字段名称
-- ##output hasContent2Flag string[36] 1;是否有字段内容关联字段名称：0-无，1-有，前端根据此字段计算是否需要进一步展开字段名称，如果有则调用接口：getPlateFieldContRelaFList_1_0_1查询子级
-- ##output plateFieldAlias string[36] 板块字段别名;板块字段别名
-- ##output norder int[>=0] 1;顺序
-- ##output plateFieldColor string[5] 黑色;字段名称颜色

select
t.guid as plateFieldGuid
,case when(t.source=2) then t.alias else (select name from coz_model_fixed_data where guid=t.name) end as plateFieldName
,case when exists(select 1 from coz_model_am_aprom_plate_field_content where del_flag='0' and relate_field_guid<>'' and plate_field_guid=t.guid) 
then '1' else '0' end as hasContent2Flag
,t.alias as plateFieldAlias
,t.norder
,'黑色' as plateFieldColor
from
coz_model_am_aprom_plate_field t
inner join
coz_model_am_aprom_plate_field_settings t1
on t1.plate_field_guid=t.guid
where
t.plate_guid='{plateGuid}' and t.del_flag='0' and t1.del_flag='0' and t1.cat_tree_code='{catTreeCode}'
order by t.norder