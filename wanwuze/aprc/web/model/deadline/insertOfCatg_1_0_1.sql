-- ##Title web-设置品类验收期限
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-设置品类验收期限
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类id，必填
-- ##input day int[>=0] NOTNULL;系统验收期限（单位：小时），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_category_deal_deadline_log(guid,deadline_guid,category_guid,day,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,guid
,category_guid
,'{day}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_category_deal_deadline
where category_guid='{categoryGuid}' and category_guid<>cattype_guid
;
update coz_category_deal_deadline
set day='{day}'
,update_by='{curUserId}'
,update_time=now()
where category_guid='{categoryGuid}' and category_guid<>cattype_guid