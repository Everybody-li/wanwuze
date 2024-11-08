-- ##Title web-新增品类字节标题
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增品类字节标题
-- ##CallType[ExSql]

-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input name string[50] NOTNULL;字节标题 （字节标题值=品类+level+段字节标题，Level动态变化），必填
-- ##input level int[>=0] NOTNULL;1，序号，第几段


insert into coz_category_name_title (guid,scene_tree_guid,level,name,del_flag,create_by,create_time,update_by,update_time)
select uuid(),
tt.scene_tree_guid
,tt.level
,tt.name
,'0'
,'{curUserId}'
,current_timestamp()
,'{curUserId}'
,current_timestamp()
from ( 
         select 
         level
         ,scene_tree_guid
         , concat('品类', level, '段字节标题') name 
         from 
         coz_category_name_tree t 
         where scene_tree_guid = '{secenGuid}' and del_flag = '0' and 
         level > ifnull(( 
                  select max(level) as maxLevel
                  from coz_category_name_title
                  where scene_tree_guid = '{secenGuid}' and del_flag = '0'
                  ),0)
         group by level
      ) tt
;