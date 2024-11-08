-- ##Title web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2022-10-02
-- ##Describe web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizCode char[6] NOTNULL;业务code，必填
-- ##input bizGuid string[4000] NOTNULL;业务guid(支持多个)，必填


# 接口弃用
# delete from coz_biz_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}_temp t 
# where t.bizguid in ({bizGuid}) and t.active_flag='0'
;

# 接口弃用
# update coz_biz_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}_temp t 
# set t.del_flag='0'
# where t.biz_guid in ({bizGuid}) and t.del_flag='2' and active_flag='1'