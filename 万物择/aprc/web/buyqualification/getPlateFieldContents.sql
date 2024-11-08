-- ##Title web-查询字段内容配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段内容配置列表
-- ##CallType[QueryData]


-- ##output key String[20] 板块字段内容候选项或文件模板key;板块字段内容候选项或文件模板key，（当板块字段内容来源=1，是固化的时候，key存的是fixedDataGuid，其他时候存具体值）
-- ##output display String[20] 板块字段内容候选项或文件模板展示值;板块字段内容候选项或文件模板展示值

select
t3.content as `key`
,case when(t.content_source<>'1') then t3.content else (select name from coz_model_fixed_data where guid=t3.content) end as display
,t3.plate_field_formal_guid as fieldGuid
from
coz_model_plate_field_content_formal t3
left join
coz_model_plate_field_formal t
on t3.plate_field_formal_guid=t.guid
where t3.del_flag=0

