-- ##Title app-上下架招聘信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-上下架招聘信息
-- ##CallType[ExSql]

-- ##input name string[50] NOTNULL;设置字段名称，必填
-- ##input value string[30] NOTNULL;设置值(on：开启，off：关闭)
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_user_biz_settings
set name='{name}'
,value='{value}'
,update_by='{curUserId}'
,update_time=now()
where user_id='{curUserId}'
;
insert into coz_user_biz_settings(guid,user_id,name,value,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{curUserId}' as user_id
,'{name}' as name
,'{value}' as value
,0 as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
from
coz_model_fixed_data
where not exists(select 1 from coz_user_biz_settings where user_id='{curUserId}' and del_flag='0')
limit 1