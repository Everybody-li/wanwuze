-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-字段名称配置-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 查询，t1有几行返回几行，字段内容配置根据t2和t3来计算：采购或供应单独计算，字段名称未添加字段内容(包括固化库和自建库)或未设置字段操作类型，则未配置，否则是已配置
-- ##Describe 表名：coz_model_am_aprom_plate_field t1,coz_model_am_aprom_plate_field_settings t2,coz_model_am_aprom_plate_field_content t3
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分：demand-采购需求，supply-供应需求

-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output plateGuid char[36] 板块guid;板块guid，前端：该值为空，则表示字段名称未关联完整，否则表示有关联完整
-- ##output plateFieldGuid char[36] 板块字段名称guid;板块字段名称guid
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
,case when(t3.guid is null) then '0' when (t3.content_source ='0' or t3.operation ='0') then '0' when (t3.content_source ='1' and (t.content_fixed_data_guid is null or t.content_fixed_data_guid='')) then '0' when ((t3.content_source ='2') and not exists(select 1 from coz_model_am_aprom_plate_field_content where plate_field_guid=t.guid and del_flag='0')) then '0' else '1' end as contOpFlag
from
coz_model_am_aprom_plate_field t
left join
coz_model_am_aprom_plate t1
on t.plate_guid=t1.guid
left join
coz_model_fixed_data t2
on t1.fixed_data_code=t2.guid and t2.del_flag='0'
left join
coz_model_am_aprom_plate_field_settings t3
on t3.plate_field_guid=t.guid and t3.cat_tree_code='{catTreeCode}'
where 
t.category_guid='{categoryGuid}' and t.del_flag='0'
order by t.norder