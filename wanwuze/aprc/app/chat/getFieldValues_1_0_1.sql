-- ##Title app-查询应聘/招聘页面字段内容候选项值
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询应聘/招聘页面字段内容候选项值
-- ##CallType[QueryData]

-- ##input fdGuid char[36] NOTNULL;固化名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
fixed_data_guid as fdGuid
,value
from
coz_model_fixed_data_value t
where t.fixed_data_guid='{fdGuid}' and t.del_flag='0' and (t.value like '%{fdName}%' or ''='{fdName}')
;
