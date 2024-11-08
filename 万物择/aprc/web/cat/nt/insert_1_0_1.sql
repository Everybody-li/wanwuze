-- ##Title web-新增品类字节内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增品类字节内容
-- ##CallType[ExSql]

-- ##input parentGuid string[36] NOTNULL;上一段字节内容guid（前端判断，没有上一段字节内容,传末级场景guid），必填
-- ##input screenGuid string[36] NOTNULL;末级场景guid，必填
-- ##input name string[100] NOTNULL;本段字节标题的字节内容，必填



INSERT INTO coz_category_name_tree(guid,scene_tree_guid,parent_guid,all_parent_id,code,name,norder,del_flag,create_by,create_time,update_by,update_time,level)
select 
UUID()
,'{screenGuid}'
,'{parentGuid}'
,ifnull((select CONCAT(ifnull(all_parent_id,''),id,',') from coz_category_name_tree where guid = '{parentGuid}'),',')
,concat('catName',CEILING(RAND()*900000+100000))
,'{name}'
,ifnull((select (max(norder)+1) from coz_category_name_tree where parent_guid='{parentGuid}' and del_flag='0'),1)
,'0'
,'-1'
,now()
,'-1'
,now() 
,ifnull((select level from coz_category_name_tree where guid='{parentGuid}'),0)+1
from
coz_cattype_fixed_data
where 
not exists(select 1 from coz_category_name_tree where name='{name}' and parent_guid='{parentGuid}' and del_flag='0')
limit 1
