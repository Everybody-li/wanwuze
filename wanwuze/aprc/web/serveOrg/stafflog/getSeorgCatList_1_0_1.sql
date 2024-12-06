-- ##Title web-查询服务机构品类权限列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务机构品类权限列表
-- ##CallType[QueryData]

-- ##input seorgGuid char[36] NOTNULL;服务机构guid，必填
-- ##input categoryName string[100] NULL;品类名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t2.guid as categoryGuid
,t2.name as categoryName
,t2.cattype_name as cattypeName
,left(t1.create_time,16) as grantTime
from
coz_serve_org_category t1
inner join
coz_category_info t2
on t1.category_guid=t2.guid
where
t1.seorg_guid=''{seorgGuid}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.name like ''%{categoryName}%'' or ''{categoryName}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;