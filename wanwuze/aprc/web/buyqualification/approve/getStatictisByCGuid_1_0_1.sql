-- ##Title web-查询品类资质审批统计列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类资质审批统计列表
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid string char[36] 品类记录guid;配置记录guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output approveFlag0 int[>=0] 0;未审批数量
-- ##output approveFlag1 int[>=0] 0;已审批数量
-- ##output approveFlag2 int[>=0] 0;审批不通过数量

PREPARE q1 FROM '
select
t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
,(select count(1) from coz_category_buy_qualification_user where category_guid=t1.guid and approve_flag=''0'') as approveFlag0
,(select count(1) from coz_category_buy_qualification_user where category_guid=t1.guid and approve_flag=''1'') as approveFlag1
,(select count(1) from coz_category_buy_qualification_user where category_guid=t1.guid and approve_flag=''2'') as approveFlag2
from
coz_category_buy_qualification t
left join 
coz_category_info t1
on t.category_guid=t1.guid
where 
t.del_flag=''0'' and (t1.name like''%{categoryName}%'' or ''{categoryName}''='''')
group by t1.guid,t1.name,t1.cattype_name
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;