-- ##Title web-新建字段内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新建字段内容
-- ##CallType[ExSql]

-- ##input fixedDataGuid char[36] NOTNULL;固化字段名称guid，必填
-- ##input name string[20] NOTNULL;字段内容名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_model_fixed_data_value(guid,fixed_data_guid,value,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,guid as fixed_data_guid
,'{name}' as value
,0 as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
from
coz_model_fixed_data
where not exists(select 1 from coz_model_fixed_data_value where value='{name}'and del_flag='0')  and guid='{fixedDataGuid}'