-- ##Title web-查询供应专员业绩管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员业绩管理
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input serveFeeFlag string[1] NOTNULL;登录用户id，必填
-- ##input gyv2UserId string[36] NULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
year,month,concat(year,''-'',month) as monthStr
from
(
select year,month as month from coz_order_gyv2_kpi where serve_fee_flag=''{serveFeeFlag}'' and (gyv2staff_user_id=''{gyv2UserId}'' or ''{gyv2UserId}''='''') group by year,month
)t
order by year,month desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
