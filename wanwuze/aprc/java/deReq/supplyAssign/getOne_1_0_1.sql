-- ##Title 需求-查询品类的指派规则信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询品类的指派规则信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid

select
t.category_guid as categoryGuid
,t.cattype_guid as cattypeGuid
,t.rule_type as ruleType
,left(t.publish_time,10) as publishTime
from
coz_category_model_supply_assign_log t
where 
t.category_guid='{categoryGuid}' 
order by t.id desc
limit 1