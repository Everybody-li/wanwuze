-- ##Title web-修改品类字节内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-修改品类字节内容
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;字节内容guid，必填
-- ##input screenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input parentGuid char[36] NOTNULL;上一段字节内容guid（前端判断，没有上一段字节内容,传末级场景guid），必填
-- ##input name string[100] NOTNULL;本段字节标题的字节内容

set @all_parent_id=(select CONCAT(all_parent_id,id,',') from coz_category_name_tree where guid='{parentGuid}' and del_flag=0)
;
set @flag3=case when(not exists(select 1 from coz_category_name_tree where name='{name}' and parent_guid='{parentGuid}' and del_flag='0')) then '1' else '0' end
;
update coz_category_name_tree
set
parent_guid=case when('{screenGuid}'='{parentGuid}') then '{screenGuid}' else '{parentGuid}' end
,name='{name}'
,all_parent_id=case when('{screenGuid}'='{parentGuid}') then '' else @all_parent_id end
where guid='{guid}' and @flag3='1'
