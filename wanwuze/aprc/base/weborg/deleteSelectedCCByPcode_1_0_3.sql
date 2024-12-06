-- ##Title web-删除选中的行政区域的父节点组系及子孙列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2022-10-02
-- ##Describe web-删除选中的行政区域的父节点组系及子孙列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid char[36] NOTNULL;业务字段guid，必填
-- ##input selectedFlag1Code string[4000] NOTNULL;当前折叠节点的半选中子级节点id(支持多个，多个逗号分隔)，必填
-- ##input allParentCode string[200] NOTNULL;组系节点code，必填
-- ##input bizCode char[6] NOTNULL;业务code，必填



update coz_biz_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}_temp t
set del_flag='2'
where t.biz_guid='{bizGuid}' and t.all_parent_code like concat('%','{allParentCode}','%')
  and (t.ncode not in({selectedFlag1Code}) or {selectedFlag1Code}='')
  and ( not exists(select 1 from sys_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} where code in ({selectedFlag1Code}) and t.all_parent_code like concat('%',all_parent_code,'%')) or {selectedFlag1Code}='');
