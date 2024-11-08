-- ##Title web-删除采购/供应路径
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-删除采购/供应路径
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;订单退货guid，必填
-- ##input pathType string[6] NOTNULL;主体类型（1：个人，2：企业），必填
-- ##input name string[50] NOTNULL;路径名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_cattype_demand_path
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{guid}'
;
update coz_cattype_supply_path
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{guid}'