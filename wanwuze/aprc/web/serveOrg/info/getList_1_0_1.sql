-- ##Title web-查询手机号更新记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询手机号更新记录
-- ##CallType[QueryData]

-- ##input seorgName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
t.guid as seorgGuid
,t.user_name as seorgName
,t.code as seorgCode
,left(t.create_time,19) as createTime
from 
coz_serve_org t
where (t.user_name like ''%{seorgName}%'' or ''{seorgName}''='''') and del_flag=''0''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;