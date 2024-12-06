-- ##Title app-应聘-应聘方式管理-目标工作管理-上下架应聘信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-上下架应聘信息
-- ##CallType[ExSql]

-- ##input recruitGuid char[36] NOTNULL;应聘信息guid，必填
-- ##input salesOn string[1] NOTNULL;上下架状态(1：上架，2：下架)
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_chat_employ
set sales_on='{salesOn}'
,update_by='{curUserId}'
,update_time=now()
where guid='{recruitGuid}'
;
