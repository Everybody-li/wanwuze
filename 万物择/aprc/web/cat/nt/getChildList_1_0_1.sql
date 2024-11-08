-- ##Title web-查询子级字节内容_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询子级字节内容_1_0_1
-- ##CallType[QueryData]

-- ##input parentGuid string[36] NOTNULL;父字节内容guid，必填
-- ##input name string[50] NULL;字节内容（模糊搜索），非必填

select 
t1.scene_tree_guid as screenGuid
,t1.all_parent_id as allParentId
,t1.parent_guid as parentGuid
,(select name from coz_category_name_tree where guid=t1.parent_guid) as parentName
,t1.guid
,t1.name
,t1.level
,t1.norder
,t1.remark
,case when exists(select 1 from coz_category_name_tree where parent_guid=t1.guid and del_flag='0') then '1' else '0' end as hasSon
,left(t1.create_time,19) as createTime
from 
coz_category_name_tree t1
where 
t1.parent_guid='{parentGuid}' and t1.del_flag='0'  and (t1.name like '{name}%' or '{name}'='')
order by t1.norder,t1.id