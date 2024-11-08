-- ##Title web-编辑机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑机构名称
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;机构信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgName string[50] NOTNULL;机构名称，必填
-- ##input type string[50] NULL;机构路径guid，必填


update coz_org_info
set 
name='{orgName}'
,type='{type}'
,update_by='{curUserId}'
,update_time=now()
where guid='{orgGuid}'
;
