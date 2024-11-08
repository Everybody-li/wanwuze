-- ##Title web-编辑品类图片
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑品类图片
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input img string[200] NOTNULL;图片地址

update coz_category_info
set img='{img}'
where 
guid='{categoryGuid}'