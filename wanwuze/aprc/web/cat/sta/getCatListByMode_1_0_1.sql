-- ##Title web-查询品类信息分页列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类信息分页列表
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（模糊搜索,查询所有传空）
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input mode string[1] NOTNULL;品类模式(品类模式：1-沟通模式，2-交易模式)，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t.guid as categoryGuid
,t.name as categoryName
,t.cattype_guid as cattypeGuid
,t.cattype_name as cattypeName
from
coz_category_info t
where (t.name like ''%{categoryName}%''or ''{categoryName}''='''')  and t.del_flag=''0'' and t.mode={mode}
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

