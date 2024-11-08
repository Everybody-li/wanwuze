-- ##Title web-查询供应机构供应品类添加列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询供应机构供应品类添加列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId string[50] NULL;品类名称（模糊搜索），非必填
-- ##input categoryName string[200] NULL;供应机构用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t1.user_id as orgUserId
,t3.name as categoryName
,t3.cattype_name as cattypeName
from
coz_org_info t1
inner join
coz_category_supplier t2
on t1.user_id=t2.user_id
inner join
coz_category_info t3
on t2.category_guid=t3.guid
where
t1.user_id=''{orgUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t3.name like ''%{categoryName}%'' or ''{categoryName}''='''')
order by t3.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;