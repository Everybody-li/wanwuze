-- ##Title web-新增品类字节标题
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增品类字节标题
-- ##CallType[ExSql]

-- ##input screenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input name string[100] NOTNULL;字节标题 （字节标题值=品类+level+段字节标题，Level动态变化），必填
-- ##input level int[>=0] NOTNULL;1，序号，第几段


insert into coz_category_name_title (guid,scene_tree_guid,level,name,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,'{screenGuid}'
,{level}
,'{name}'
,'0'
,'-1'
,now()
,'-1'
,now()
from
coz_cattype_fixed_data
where 
(ifnull((select max(level) from coz_category_name_title where scene_tree_guid='{screenGuid}' and del_flag='0'),0)+1)={level}
limit 1