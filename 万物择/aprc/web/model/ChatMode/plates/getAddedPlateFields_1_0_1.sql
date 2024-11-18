-- ##Title web-查询已添加的字段名称配置列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-查询已添加的字段名称配置列表
-- ##CallType[QueryData]

-- ##input catTreeCode string[50] NOTNULL;采购还是供应（supply：供应，demand：采购）
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input bizType int[>=0] NOTNULL;业务类型：1-供需需求信息配置，2-供应报价信息配置，3-简历需求信息配置，4-采购资质信息配置，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output plateFieldGuid char[36] 板块字段名称guid;板块字段名称guid
-- ##output plateFieldName string[50] 板块字段名称;板块字段名称。
-- ##output plateFieldCode string[50] 板块字段名称code;板块字段名称code
-- ##output source int[>=0] 板块字段名称来源;板块字段名称来源（1：固化，2：自建）
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output plateTypeGuid char[36] 板块类型guid;板块类型guid（关联了板块类型则不为空）
-- ##output catTreeCode string[50] supply;采购还是供应（supply：供应，demand：采购）

select
t.guid as plateFieldGuid
,case when(t.source=2) then t.name else (select name from coz_model_fixed_data where code=t.name) end as plateFieldName
,(select code from coz_model_fixed_data where code=t.name) as plateFieldCode
,t1.guid as plateGuid
,concat(t2.name,'(',t1.alias,')') as plateName
,t1.alias as plateAlias
,t.source
,t.alias as plateFieldAlias
,t.category_guid as categoryGuid
,t.plate_guid as plateGuid
,t.cat_tree_code as catTreeCode
,case when (t.operation='0' or t.content_source='0' or ((t.operation='1' or t.operation='2') and (t.content_source='1' or t.content_source='2') and not exists(select 1 from coz_model_chat_plate_field_content where plate_field_guid=t.guid and del_flag='0'))) then '0' else '1' end as contOpFlag
from
coz_model_chat_plate_field t
left join
coz_model_chat_plate t1
on t.plate_guid=t1.guid
left join
coz_model_fixed_data t2
on t1.fixed_data_code=t2.code and t2.del_flag='0'
where 
t.cat_tree_code='{catTreeCode}' and t.category_guid='{categoryGuid}' and t.del_flag='0'
order by t.norder,t.id