-- ##Title 运营经理操作系统-品类交易信息-交易信息信息管理-审批/交易模式-修改品类使用状态
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 运营经理操作系统-品类交易信息-交易信息信息管理-审批/交易模式-修改品类使用状态
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input catOpenStatus enum[0,1] NOTNULL;品类使用状态(对应列APP端操作):0-关闭,1-开放
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_category_info
set open_status='{catOpenStatus}'
,update_by='{curUserId}'
,update_time=now()
where
guid='{categoryGuid}'