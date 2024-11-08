-- ##Title web-变更品类字节内容节点顺序
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-变更品类字节内容节点顺序
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;节点guid（场景guid），必填
-- ##input oldNorder int[>=0] NOTNULL;节点顺序，必填
-- ##input newNorder int[>=0] NOTNULL;节点顺序，必填

set @parentguid=(select parent_guid from coz_category_name_tree where guid ='{guid}' and del_flag='0')
;
set @flag1=case when((select norder from coz_category_name_tree where guid='{guid}')={oldNorder}) then 1 else 0 end
;
set @norderflag=({newNorder}-{oldNorder})
;
update coz_category_name_tree
set norder=norder-1
where norder<={newNorder} and norder>={oldNorder} and parent_guid=@parentguid and @norderflag>=0 and guid<>'{guid}' and @flag1=1 and del_flag='0'
;
update coz_category_name_tree
set norder=norder+1
where norder>={newNorder} and norder<={oldNorder} and parent_guid=@parentguid and @norderflag<=0 and guid<>'{guid}' and @flag1=1 and del_flag='0'
;
update coz_category_name_tree
set norder={newNorder}
where guid='{guid}' and @flag1=1