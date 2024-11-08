-- ##Title 字节内容guid，必填
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 字节内容guid，必填
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;字节内容guid，必填

set @parentGuid=(select parent_guid from coz_category_name_tree where guid='{guid}')
;
set @allParentId=ifnull((select CONCAT(ifnull(all_parent_id,''),id,',') from coz_category_name_tree where guid=@parentGuid),'0')
;	
set @norder=ifnull((select (max(norder)+1) from coz_category_name_tree where parent_guid=@parentGuid and del_flag='0'),1)
;
update coz_category_name_tree 
set all_parent_id=@allParentId
,norder=@norder
where guid='{guid}'