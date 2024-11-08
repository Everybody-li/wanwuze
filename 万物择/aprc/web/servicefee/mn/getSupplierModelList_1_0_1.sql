-- ##Title web-查询某一品类供方型号列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询某一品类供方型号列表
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方用户表guid，必填
-- ##input modelName string[50] NULL;型号姓名(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t1.guid as modelGuid
,t1.name as modelName
from
coz_category_supplier_model t1
where
t1.supplier_guid=''{supplierGuid}''  and t1.del_flag=''0'' and (t1.name like''%{modelName}%'' or ''{modelName}''='''')
order by id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;