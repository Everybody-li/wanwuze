-- ##Title web-查询验收期限品类已设置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询验收期限品类已设置列表
-- ##CallType[QueryData]

-- ##input category_name string[500] NULL;品类名称(查询所有则传空)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output category_guid char[36] 品类id;品类id
-- ##output category_name string[50] 品类名称;品类名称
-- ##output day int[>=0] 1;验收期限（单位：小时）
-- ##output updateTime string[19] 创建时间;创建时间（每个品类取未删除的最近时间）
-- ##output cattypeName string[50] 品类类型名称;品类类型名称

PREPARE q1 FROM '
select
t1.guid as categoryGuid
,t1.name as categoryName
,t.day
,t.create_time as createTime
,t1.cattype_name as cattypeName
,left(t.update_time,16) as updateTime
from
coz_category_deal_deadline t
inner join
coz_category_info t1
on t.category_guid=t1.guid
where 
(t1.name like''%{category_name}%'' or ''{category_name}''='''') and t.del_flag=''0'' and t1.del_flag=''0'' and t.day>0
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;