-- ##Title 查询需求场景儿子节点列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 查询供需主体/采购供应类型/场景的儿子列表等
-- ##CallType[QueryData]

-- ##input parentGuid char[36] NULL;节点guid（guid是唯一的），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
all_parent_id as allParentId
,parent_guid as parentGuid
,guid
,name
,level
,norder
,remark
,case when exists(select 1 from coz_category_scene_tree where parent_guid=t1.guid and del_flag='0') then '1' else 0 end as hasSon
,left(create_time,19) as createTime
from
coz_category_scene_tree t1
where  parent_guid ='{parentGuid}' and del_flag='0'
order by norder,id