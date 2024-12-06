-- ##Title web-编辑品类字节标题
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑品类字节标题
-- ##CallType[ExSql]

-- ##input titleGuid char[36] NOTNULL;字节标题guid，必填
-- ##input name string[100] NOTNULL;字节标题（若用户没填写，前端默认生成规则：品类N+1段字节标题，N取接口返回，有几条数据，N=几，例如返回0条数据，则生成品类1段字节标题），必填

update coz_category_name_title 
set name='{name}'
where
guid='{titleGuid}'