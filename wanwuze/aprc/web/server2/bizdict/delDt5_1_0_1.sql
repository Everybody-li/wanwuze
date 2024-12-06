-- ##Title web-服务专员-删除标签
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务专员-删除标签
-- ##CallType[ExSql]

-- ##input bizdict5Guid char[36] NOTNULL;服务专员标签名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_serve2_bizdict
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{bizdict5Guid}'
;