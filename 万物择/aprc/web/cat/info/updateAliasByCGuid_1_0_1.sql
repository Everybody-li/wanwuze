-- ##Title web-编辑品类别名
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑品类别名
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input aliasName string[20] NULL;别名名称（多个逗号分隔）
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_info
set alias='{aliasName}'
where 
guid='{categoryGuid}'