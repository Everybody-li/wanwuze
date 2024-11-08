-- ##Title web-修改品类名称图片
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-修改品类名称图片
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input img string[200] NOTNULL;图片地址
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_info
set img='{img}'
,img_upd_by='{curUserId}'
,update_by='{curUserId}'
,update_time=now()
where 
guid='{categoryGuid}'