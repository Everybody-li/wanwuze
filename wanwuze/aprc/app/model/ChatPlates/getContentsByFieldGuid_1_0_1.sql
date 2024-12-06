-- ##Title app-沟通模式-根据字段guid查询字段内容配置列表(仅针对自建内容库的)
-- ##Author lith
-- ##CreateTime 2024-11-19
-- ##Describe
-- ##CallType[QueryData]

-- ##input fieldGuid char[36] ;字段guid

-- ##output key String[200] ;板块字段内容候选项或文件模板key，（当板块字段内容来源=1，是固化的时候，key存的是fixedDataGuid，其他时候存具体值）
-- ##output display String[200] ;板块字段内容候选项或文件模板展示值
-- ##output valueGuid char[36] ;板块字段内容候选项guid


 select guid as valueGuid, `content` as `key`, `content` as display
from
    coz_model_chat_plate_field_content_formal
where plate_field_formal_guid = '{fieldGuid}';