-- ##Title web-删除品类名称
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-删除品类名称
-- ##CallType[Exsql]

-- ##input categoryGuid char[36] NULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_info
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{categoryGuid}' 
;
update coz_category_supplydemand
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where category_guid='{categoryGuid}' 
;