-- ##Title app-应聘-应聘方式管理-目标工作管理-删除
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe  仅工作信息是下架状态可删除
-- ##CallType[ExSql]

-- ##input recruitGuid char[36] NOTNULL;应聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_chat_employ_detail t1 
inner join coz_chat_employ t2 on t1.employ_guid = t2.guid
set t1.del_flag='2'
  , t1.update_by='{curUserId}'
  , t1.update_time=now()
where t1.employ_guid = '{recruitGuid}'
  and t2.sales_on = '2'
;
update coz_chat_employ
set del_flag='2'
  , update_by='{curUserId}'
  , update_time=now()
where guid = '{recruitGuid}'
  and sales_on = '2'
;
