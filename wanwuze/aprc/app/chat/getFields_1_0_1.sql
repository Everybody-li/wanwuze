-- ##Title app-应聘/招聘信息页面字段-无值
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-应聘/招聘信息页面字段-无值
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
code as fdCode
,guid as fdGuid
,name as fdName
from
coz_model_fixed_data t
where type=3 and biz_type='5' and (display_type='1' or display_type='3') and del_flag='0'
;
