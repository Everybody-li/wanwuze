-- ##Title web-根据板块名称guid查询板块字段名称列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-根据板块名称guid查询板块字段名称列表
-- ##CallType[QueryData]

-- ##input plateGuid char[36] NOTNULL;板块类型guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output plateFieldGuid char[36] 板块字段guid;板块字段guid
-- ##output plateFieldName string[50] 板块字段名称;板块字段名称。
-- ##output plateFieldAlias string[50] 板块字段别名;板块字段别名
-- ##output norder int[>=0] 1;板块字段名称顺序

select
case when(t.source=2) then t.name else (select name from coz_model_fixed_data where code=t.name) end as plateFieldName
,guid as plateFieldGuid
,alias as plateFieldAlias
,t.norder
from
coz_model_chat_plate_field t
where 
plate_guid='{plateGuid}' and del_flag='0'
order by t.norder,t.id