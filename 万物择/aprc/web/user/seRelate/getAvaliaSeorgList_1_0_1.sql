-- ##Title web-供应专员用户管理-查询可关联服务机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应专员用户管理-查询可关联服务机构列表
-- ##CallType[QueryData]

-- ##input seorgName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t1.guid as seorgGuid
,t1.user_name as seorgName
,left(t1.create_time,16) as registerTime
from
coz_serve_org t1
where
t1.del_flag=''0'' and (t1.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;