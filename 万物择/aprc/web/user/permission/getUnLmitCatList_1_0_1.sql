-- ##Title web-查询未被限制采购/供应的品类列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询未被限制采购/供应的品类列表
-- ##CallType[QueryData]

-- ##input type int[>=0] NOTNULL;权限类型（4：品类采购操作权限，5：品类供应操作权限）
-- ##input userId char[36] NOTNULL;品类名称（模糊搜索），非必填
-- ##input categoryName string[50] NULL;品类名称（模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid char[36] 板块字段名称guid;板块字段名称guid
-- ##output categoryName string[50] 板块字段内容值;板块字段内容值

PREPARE q1 FROM '
select
t.guid as categoryGuid
,t.name as categoryName
from
coz_category_info t
where 
t.del_flag=0 and not exists(select 1 from coz_app_user_permission_detail where biz_guid=t.guid and type={type} and user_id=''{userId}'' and del_flag=''0'') and (t.name like''%{categoryName}%'' or ''{categoryName}''='''')
order by id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
