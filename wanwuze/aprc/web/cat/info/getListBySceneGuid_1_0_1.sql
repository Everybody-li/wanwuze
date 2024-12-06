-- ##Title web-根据需求场景查询品类信息分页列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-根据需求场景查询品类信息分页列表
-- ##CallType[QueryData]

-- ##input sceneGuid char[36] NOTNULL;末级场景guid，必填
-- ##input categoryName string[50] NULL;字节内容名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
t2.scene_tree_guid as sceneGuid
,t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
from
coz_category_info t1
inner join
coz_category_supplydemand t2
on t2.category_guid=t1.guid
where 
t2.scene_tree_guid=''{sceneGuid}'' and t1.del_flag=''0''  and t2.del_flag=''0'' and (t1.name like ''%{categoryName}%'' or ''{categoryName}''='''') and t1.img_upd_flag=''0''
order by t1.id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;