-- ##Title web-删除沟通/服务话术信息管理
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除沟通/服务话术信息管理
-- ##CallType[ExSql]

-- ##input pfelangGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_serve2_pfelang
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{pfelangGuid}'
