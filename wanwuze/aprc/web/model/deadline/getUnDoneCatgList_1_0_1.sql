-- ##Title web-查询验收期限品类未设置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询验收期限品类未设置列表
-- ##CallType[QueryData]

-- ##output categoryName string[500] NULL;品类名称(查询所有则传空)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


PREPARE q1 FROM '
select
t.guid as categoryGuid
,t.name as categoryName
,t.cattype_name as cattypeName
from
coz_category_info t
inner join
coz_category_deal_deadline t1
on t.guid=t1.category_guid
where 
t1.day=''0'' and (t.name like''%{categoryName}%'' or ''{categoryName}''='''') and t.del_flag=''0''and t1.del_flag=''0''
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;