-- ##Title web-询价专员-查询已保存的品类标签设置-品类名称列表数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-询价专员-查询已保存的品类标签设置-品类名称列表数据
-- ##CallType[QueryData]

-- ##input categoryName string[500] NULL;机构名称(模糊搜索)，非必填
-- ##input userId string[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.cattype_guid as cattypeGuid
,t2.name as cattypeName
,t1.guid as categoryGuid
,t1.name as categoryName
from 
coz_category_info t1
inner join
coz_cattype_fixed_data t2
on t1.cattype_guid=t2.guid
inner join
coz_server2_sys_user_category t3
on t1.guid=t3.category_guid
where 
(t1.name like''%{categoryName}%'' or ''{categoryName}''='''') and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t3.user_id=''{userId}''
order by t3.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;