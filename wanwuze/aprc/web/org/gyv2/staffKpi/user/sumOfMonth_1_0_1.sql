-- ##Title web-查询供应专员业绩管理-供应专员成果
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员业绩管理-供应专员成果
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input serveFeeFlag string[1] NOTNULL;登录用户id，必填
-- ##input gyv2UserId string[36] NULL;登录用户id，必填
-- ##input year string[4] NOTNULL;年度(格式：0000)，必填
-- ##input month string[2] NOTNULL;月份(格式：00)，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
*
from
(
select 
concat(''(+86)'',t2.phonenumber) as phonenumber
,t2.user_name as userName
,t2.nick_name as nickName
,t1.money
,case when(t2.del_flag=''0'') then ''0'' else ''1'' end as deleteFlag
,concat(''{year}'',''-'',''{month}'') as month
from
(
select 
cast(sum(t1.money)/100 as decimal(18,2)) as money
,t1.gyv2staff_user_id as userId
from 
coz_order_gyv2_kpi t1
inner join
sys_user t2
on t1.gyv2staff_user_id=t2.user_id
where 
t1.serve_fee_flag=''{serveFeeFlag}'' and (t1.gyv2staff_user_id=''{gyv2UserId}'' or ''{gyv2UserId}''='''') and t1.year=''{year}'' and t1.month=''{month}'' and (t2.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
group by t1.gyv2staff_user_id
)t1
inner join
sys_user t2
on t1.userId=t2. user_id
)t
order by month desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
