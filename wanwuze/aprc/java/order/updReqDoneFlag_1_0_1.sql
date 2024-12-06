-- ##Title 更新采购需求完成状态
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供方-添加品类
-- ##CallType[ExSql]

-- ##input requestGuid string[200] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_demand_request
set done_flag='1'
,done_flag_xjsuser_read_flag='1'
,update_by='{curUserId}'
,update_time=now()
where guid='{requestGuid}'

