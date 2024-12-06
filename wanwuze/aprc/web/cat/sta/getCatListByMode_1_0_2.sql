-- ##Title web-查询品类信息分页列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类信息分页列表
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（模糊搜索,查询所有传空）
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input mode string[1] NOTNULL;品类模式(品类模式：1-沟通模式，2-交易模式)，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid

PREPARE p1 FROM '
select
t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_guid as cattypeGuid
,t1.cattype_name as cattypeName
from
coz_category_info t1
inner join
coz_category_supplydemand t2
on t1.guid=t2.category_guid
inner join
coz_category_scene_tree t3
on t2.scene_tree_guid=t3.guid
where (t1.name like ''%{categoryName}%''or ''{categoryName}''='''')  and t1.del_flag=''0'' and t3.sd_path_guid=''{sdPathGuid}'' and t1.mode={mode}
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

