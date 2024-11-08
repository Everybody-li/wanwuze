-- ##Title web-删除选中的行政区域的父节点组系及子孙列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2022-10-02
-- ##Describe web-删除选中的行政区域的父节点组系及子孙列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid char[36] NOTNULL;业务字段guid，必填
-- ##input selectedFlag1Id string[4000] NOTNULL;当前折叠节点的半选中子级节点id(支持多个，多个逗号分隔)，必填
-- ##input allParentId string[200] NULL;当前节点的组系节点，必填



update coz_biz_city_code_temp t
set del_flag='2'
where t.biz_guid='{bizGuid}' and t.all_parent_id like concat('%','{allParentId}','%') 
and (t.id not in({selectedFlag1Id}) or '{selectedFlag1Id}'='''') 
and ( not exists(select 1 from sys_city_code where id in ({selectedFlag1Id}) and t.all_parent_id like concat('%',all_parent_id,'%')) or '{selectedFlag1Id}'='''');
