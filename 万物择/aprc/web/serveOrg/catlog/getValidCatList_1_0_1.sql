-- ##Title web-查询机构品类权限管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询机构品类权限管理列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input seorgGuid char[36] NOTNULL;服务机构信息guid，必填
-- ##input categoryName string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填



PREPARE q1 FROM '
select
t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
,left(t.create_time,16) as grantTime
from
coz_serve_org_category t
inner join
coz_category_info t1
on t.category_guid=t1.guid
where t1.del_flag=''0'' and t.del_flag=''0'' and t.seorg_guid=''{seorgGuid}'' and (t1.name like ''%{categoryName}%'' or ''{categoryName}''='''')
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

