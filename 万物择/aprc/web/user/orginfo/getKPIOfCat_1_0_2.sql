-- ##Title web-供应机构用户-查询供应成果列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应机构用户-查询供应成果列表
-- ##CallType[QueryData]

-- ##input categoryName string[200] NULL;品类名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgUserId char[36] NOTNULL;供应机构用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
t2.category_guid as categoryGuid
,t2.category_name as categoryName
,t2.cattype_name as cattypeName
,t2.cattype_guid as cattypeGuid
,count(1) as orderNum
from
coz_order t1
inner join
coz_demand_request t2
on t1.request_guid=t2.guid
where 
t1.accept_status=''1'' and t1.supply_user_id=''{orgUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.category_name like ''%{categoryName}%'' or ''{categoryName}''='''')
group by t2.category_guid,t2.category_name,t2.cattype_name,t2.cattype_guid
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

