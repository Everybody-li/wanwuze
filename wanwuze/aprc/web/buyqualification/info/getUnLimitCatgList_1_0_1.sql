-- ##Title web-查询未管制的品类列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询未管制的品类列表
-- ##CallType[QueryData]

-- ##input categoryName string[500] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称


PREPARE q1 FROM '
	select
	guid as categoryGuid
	,name as categoryName
	from
	coz_category_info t
	where 
	(t.name like ''%{categoryName}%'' or ''{categoryName}''='''') and t.del_flag=''0'' and not exists(select 1 from coz_category_buy_qualification where category_guid=t.guid and del_flag=''0'')
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;