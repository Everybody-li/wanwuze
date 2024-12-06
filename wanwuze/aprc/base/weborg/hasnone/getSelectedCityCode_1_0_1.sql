-- ##Title web-查询已选中的行政区域列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询已选中的行政区域列表
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;业务guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t.code
,t.id
,t.parent_code as parentCode
,t.all_parent_code as allParentCode
,t.path_name as name
from 
sys_city_code_hasnone t
inner join 
coz_biz_city_code_hasnone_temp t1
on t.code=t1.ncode and t1.del_flag=''0''
where t1.biz_guid=''{bizGuid}'' and t1.del_flag=''0''
order by t.id
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;