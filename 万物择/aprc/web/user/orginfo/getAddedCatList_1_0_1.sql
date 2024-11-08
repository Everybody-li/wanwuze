-- ##Title web-供应机构用户-查询供应品类添加列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应机构用户-查询供应品类添加列表
-- ##CallType[QueryData]

-- ##input categoryName string[200] NULL;品类名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId char[36] NOTNULL;供应机构用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t3.guid as categoryGuid
,t3.name as categoryName
,t3.cattype_name as cattypeName
,t3.cattype_guid as cattypeGuid
from
coz_org_info t1
inner join
coz_category_supplier t2
on t1.user_id=t2.user_id
inner join
coz_category_info t3
on t2.category_guid=t3.guid
where 
t1.user_id=''{orgUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and (t3.name like ''%{categoryName}%'' or ''{categoryName}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

