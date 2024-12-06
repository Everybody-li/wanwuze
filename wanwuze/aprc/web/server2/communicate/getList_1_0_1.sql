-- ##Title web-查询沟通/服务话术信息管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询沟通/服务话术信息管理
-- ##CallType[QueryData]

-- ##input name string[50] NULL;登录用户id，必填
-- ##input type string[1] NOTNULL;类型（1：沟通话术，2：服务话术）必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t1.guid as pfelangGuid
,t1.file_name as fieldName
,t1.file_value as fieldValue
,left(t1.create_time,16) as createTime
from 
coz_serve2_pfelang t1
where t1.type=''{type}'' and del_flag=''0'' and (t1.file_name like ''%{name}%'' or ''{name}''='''')
order by t1.id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;