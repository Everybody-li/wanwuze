-- ##Title web-删除选中的行政区域的父节点组系及子孙列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2022-10-02
-- ##Describe web-删除选中的行政区域的父节点组系及子孙列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid string[1000] NOTNULL;业务字段guid，必填


delete from coz_biz_city_code_temp where biz_guid in ({bizGuid})
