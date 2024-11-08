-- ##Title web-查看需方违约处罚收取列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看需方违约处罚收取列表
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output year string[4] 0000;裁决结果年份（格式：0000）
-- ##output month string[4] 00;裁决结果月份（格式：00）
-- ##output waitPayFee decimal[<=0] 1;未结费用（保留2位小数）
-- ##output hadPayFee decimal[<=0] 1;已结费用（保留2位小数）
-- ##output waitPayNum int[<=0] 1;未结笔数
-- ##output hadPayNum int[<=0] 1;已结笔数

PREPARE q1 FROM '
select
LEFT(createDate,4) as year
,RIGHT(createDate,2) as month
,t.waitPayFee
,t.waitPayNum
,t.hadPayFee
,t.hadPayNum
,(t.waitPayFee+t.hadPayFee) as totalFee
,(t.waitPayNum+t.hadPayNum) as totalNum
from
(
	select 
	createDate
	,sum(waitPayFee) as waitPayFee
	,sum(waitPayNum) as waitPayNum
	,sum(hadPayFee) as hadPayFee
	,sum(hadPayNum) as hadPayNum
	from
	(
		select
		left(t.create_time,7) as createDate
		,sum(cast(t.fee/100 as decimal(18,2))) as waitPayFee
		,count(1) as waitPayNum
		,0.00 as hadPayFee
		,0 as hadPayNum
		from
		coz_order_judge_fee t
		left join
		coz_order_judge t1
		on t.judge_guid=t1.guid
		where 
		t.pay_type=0 and t.del_flag=0 and t.fee_type=''1'' and t1.disobey_object=''1''
		group by left(t.create_time,7)
		union all
		select
		left(t.create_time,7) as createDate
		,0.00 as waitPayFee
		,0 as waitPayNum
		,sum(cast(t.fee/100 as decimal(18,2))) as hadPayFee
		,count(1) as hadPayNum
		from
		coz_order_judge_fee t
		left join
		coz_order_judge t1
		on t.judge_guid=t1.guid
		where 
		t.pay_type>0 and t.del_flag=0 and t.fee_type=''1'' and t1.disobey_object=''1''
		group by left(t.create_time,7)
	)t
	group by createDate
)t
order by createDate desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;