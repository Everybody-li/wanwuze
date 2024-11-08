-- ##Title 根据code模糊查询数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据code模糊查询数据
-- ##CallType[QueryData]

-- ##input name string[30] NULL;区域编码，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填
-- ##input guid string[1000] NULL;已选中的区域编码guid(可多个)，非必填
-- ##input code string[1000] NULL;已选中的区域编码code(可多个)，非必填
-- ##input level int[>=0] NOTNULL;行政区域层级
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
guid
,case when(''{code}'' like concat(''%'',code,''%'')) then ''1'' else ''0'' end as selectedFlag
,id
,code
,parent_code as parentCode
,all_parent_id as allParentId
,path_name as pathName
,level
from sys_city_code t
where (path_name like ''%{name}%'' or ''{name}''='''') and version=1 and level={level}
order by id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;