-- ##Title web-查询需方已经添加供方未添加的字段名称列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-查询需方已经添加供方未添加的字段名称列表
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input fieldName string[50] NULL;字段名称（模糊匹配），非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output fixedDataGuid char[36] 添加的固化库字段名称guid;添加的固化库字段名称guid
-- ##output plateFieldName string[100] 自建的字段名称;自建的字段名称
-- ##output plateFieldCode string[50] 板块字段名称code;板块字段名称code
-- ##output source int[>=0] 板块字段名称来源;板块字段名称来源（1：固化，2：自建）

select
plateFieldGuid
,plateFieldName
,source
,plateFieldCode
from
(
select
t.guid as plateFieldGuid
,(select code from coz_model_fixed_data where code=t.name) as plateFieldCode
,case when(source='2') then t.name else (select name from coz_model_fixed_data where code=t.name) end as plateFieldName
,t.create_time
,t.source
,t.norder
,t.id
from
coz_model_chat_plate_field t
where 
cat_tree_code='demand' and category_guid='{categoryGuid}' and (operation='1' or operation='2' or operation='3') and del_flag='0' and not exists(select 1 from coz_model_chat_plate_field where cat_tree_code='supply' and category_guid='{categoryGuid}'and  del_flag='0' and name=t.name)
)t
where (plateFieldName like '%{fieldName}%' or '{fieldName}'='') 
order by id