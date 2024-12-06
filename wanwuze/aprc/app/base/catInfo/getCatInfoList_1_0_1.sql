-- ##Title web-查询产品名称库内容列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询产品名称库内容列表
-- ##CallType[QueryData]

-- ##input contentFDCode string[11] NOTNULL;固化内容code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t2.guid as ''key''
,t2.name as display
from 
coz_cattype_fixed_data t1
inner join
coz_category_info t2
on t1.guid=t2.cattype_guid
where t1.guid=''43cac285-f1ce-11ec-bace-0242ac120003'' and t1.del_flag=''0'' and t2.del_flag=''0'' and ''{contentFDCode}''=''c00016''
order by t2.id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;