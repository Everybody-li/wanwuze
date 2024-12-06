-- ##Title 根据品类类型guid修改品类类型图片
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 根据品类类型guid修改品类类型图片
-- ##CallType[ExSql]

-- ##input cattypeGuid char[36] NOTNULL;品类类型Guid，必填
-- ##input img string[200] NOTNULL;图片地址
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_cattype_fixed_data
set img='{img}'
,update_by='{curUserId}'
,update_time=now()
where 
guid='{cattypeGuid}'