-- ##Title web-查询系统业务字典数据选择列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询系统业务字典数据选择列表
-- ##CallType[QueryData]

-- ##input type string[1] NOTNULL;字典类型（1-机构名称，2-机构类型，3-角色类型，4-注册(服务)区域，5-服务专员标签），必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.type as dataType
,t1.guid as dataGuid
,t1.name
from 
coz_serve2_bizdict t1
where 
t1.type=''{type}'' and t1.del_flag=''0'' and (t1.name like''%{name}%'' or ''{name}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;