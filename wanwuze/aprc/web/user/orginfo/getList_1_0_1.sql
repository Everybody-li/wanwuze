-- ##Title web-供应机构用户-查询供应机构用户列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应机构用户-查询供应机构用户列表
-- ##CallType[QueryData]

-- ##input orgName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填

PREPARE q1 FROM '
select 
t.guid as orgGuid
,t.name as orgName
,t.user_id as orgUserId
,left(t.create_time,16) as createTime
from 
coz_org_info t
where 
name like''%{orgName}%'' and t.del_flag=''0''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;