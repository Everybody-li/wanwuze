-- ##Title web-查询固化内容信息管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询固化内容信息管理
-- ##CallType[QueryData]

-- ##output demandName string[50] 采购字段名称;采购字段名称
-- ##output supplyName string[50] 供应字段名称;供应字段名称

select
demandName
,supplyName
from
(
select 1 as idx,(select name from coz_model_fixed_data where code='f00004') as demandName,(select name from coz_model_fixed_data where code='f00005') as supplyName
union all
select 2 as idx,(select name from coz_model_fixed_data where code='f00004') as demandName,(select name from coz_model_fixed_data where code='f00006') as supplyName
union all
select 3 as idx,(select name from coz_model_fixed_data where code='f00007') as demandName,(select name from coz_model_fixed_data where code='f00008') as supplyName
)t
order by demandName,idx