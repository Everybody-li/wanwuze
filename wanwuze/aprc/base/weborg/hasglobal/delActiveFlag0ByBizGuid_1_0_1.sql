-- ##Title web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2022-10-02
-- ##Describe web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid string[4000] NOTNULL;业务guid(支持多个)，必填

delete from coz_biz_city_code_hasnone_temp t where t.biz_guid in ({bizGuid}) and t.active_flag='0'
;
update coz_biz_city_code_hasnone_temp t 
set t.del_flag='0'
where t.biz_guid in ({bizGuid}) and t.del_flag='2' and active_flag='1'