-- ##Title web-查询固化内容信息管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询固化内容信息管理
-- ##CallType[QueryData]

-- ##input fixedDataGuid char[36] NULL;固化库板块名称guid，必填

-- ##output fixedDataGuid char[36] 固化库板块名称guid;固化库板块名称guid
-- ##output fdValueGuid char[36] 字段内容guid;字段内容guid
-- ##output value string[20] 字段内容;字段内容


select
fixed_data_guid as fixedDataGuid
,guid as fdValueGuid
,value
from
coz_model_fixed_data_value t
where fixed_data_guid='{fixedDataGuid}' and del_flag='0'
order by t.create_time
;
