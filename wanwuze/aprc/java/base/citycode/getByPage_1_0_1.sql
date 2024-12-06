-- ##Title 根据code模糊查询数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据code模糊查询数据
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select 
*
from sys_city_code 
limit ?,?;
';

SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;
