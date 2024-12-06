-- ##Title web-查询某一品类供方数量统计-按型号名称_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询某一品类供方数量统计-按型号名称_1_0_1
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
sum(orgSupplierCount) as orgSupplierCount
,sum(personalSupplierCount) as personalSupplierCount
,user_type as userType
from
(
select 
0 as orgSupplierCount
,count(1) as personalSupplierCount
,user_type
from
coz_category_supplier t
where
category_guid=''{categoryGuid}''and del_flag=''0'' and user_type=''1''
union all
select 
count(1) as orgSupplierCount
,0 as personalSupplierCount
,user_type
from
coz_category_supplier t
where
category_guid=''{categoryGuid}''and del_flag=''0'' and user_type=''2''
)t
group by t.user_type
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;