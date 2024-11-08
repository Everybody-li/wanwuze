-- ##Title web-查询交易收入管理-月度详情(某月份下的所有日期)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易收入管理-月度详情(某月份下的所有日期)
-- ##CallType[QueryData]

-- ##input serveFeeFlag string[1] NOTNULL;服务收费标志(0-免费，1-收费)，必填
-- ##input gyv2UserId string[36] NOTNULL;供应专员用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input year char[4] NOTNULL;年度，必填
-- ##input month char[2] NOTNULL;结算机构guid，必填
-- ##input orgName string[50] NULL;机构名称（模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
orgName
,orgGuid
,relateTime
,registerTime
,sum(money) as money

,orgUserId
from
(
select
t2.name as orgName
,t2.guid as orgGuid
,left(t3.create_time,16) as relateTime
,left(t2.create_time,16) as registerTime
,cast(ifnull(t1.money,0.00)/100 as decimal(18,2)) as money

,t2.user_id as orgUserId
,t2.id
from
coz_order_gyv2_kpi t1
inner join
coz_org_info t2
on t1.org_user_id=t2.user_id
inner join
coz_org_gyv2_relate_staff_log t3
on t1.gyv2re_stalog_guid=t3.guid
where
t1.gyv2staff_user_id=''{gyv2UserId}'' and t1.serve_fee_flag=''{serveFeeFlag}'' and t3.del_flag=''0''and t1.year=''{year}'' and t1.month=''{month}'' and (t2.name like ''%{orgName}%'' or ''{orgName}''='''')
)t
group by orgName,orgGuid,relateTime,registerTime,orgUserId,id
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

