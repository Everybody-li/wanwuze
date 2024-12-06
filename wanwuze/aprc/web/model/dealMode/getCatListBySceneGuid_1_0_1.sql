-- ##Title web-根据需求场景查询未发布过供需需求信息配置的品类信息分页列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-根据需求场景查询未发布过供需需求信息配置的品类信息分页列表
-- ##CallType[QueryData]

-- ##input categoryName string[500] NULL;品类名称，非必填
-- ##input sceneGuid string[36] NOTNULL;需求场景guid，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填



PREPARE p1 FROM '
select
t.guid as categoryGuid
,t.name as categoryName
,t1.scene_tree_guid as sceneGuid
,t.cattype_name as cattypeName
from
coz_category_info t
inner join
coz_category_supplydemand t1
on t1.category_guid=t.guid
where (t.name like ''%{categoryName}%''or ''{categoryName}''='''')  and t.del_flag=''0'' and t1.scene_tree_guid=''{sceneGuid}'' and not exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getModeTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log where category_guid=t.guid)
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;
