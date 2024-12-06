-- ##Title web-判断供方必填的固化字段名称是否已经配置
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-判断供方必填的固化字段名称是否已经配置
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input fixedDataCode char[36] NOTNULL;采购方正在添加的固化字段名称固化信息表code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output demandName string[50] 需方已经添加的字段名称;需方已经添加的字段名称
-- ##output supplyName string[50] 供方未添加需方已添加的固化的对应供应名称;供方未添加需方已添加的固化的对应供应名称
-- ##output fixedDataCode char[36] 供方未添加需方已添加的固化的对应字段名称;供方未添加需方已添加的固化的对应字段名称

select
demandName
,supplyName
,fixedDataCode
from
(
select
(select name from coz_model_fixed_data where code='f00004') as demandName
,t1.name as supplyName
,t1.code as fixedDataCode
from
coz_model_fixed_data t1
where 
(t1.code='f00005' or t1.code='f00006') and '{fixedDataCode}'='f00004' and t1.name!=''
)t
where 
not exists(select 1 from coz_model_chat_plate_field where name=t.fixedDataCode and category_guid='{categoryGuid}'and del_flag='0' and cat_tree_code='supply' )