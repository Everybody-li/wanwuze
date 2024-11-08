-- ##Title web-添加管制品类
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-添加管制品类
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_category_buy_qualification(guid,category_guid,create_by,create_time,update_by,update_time,del_flag)
select
UUID()
,'{categoryGuid}'
,'1'
,now()
,'1'
,now()
,'0'