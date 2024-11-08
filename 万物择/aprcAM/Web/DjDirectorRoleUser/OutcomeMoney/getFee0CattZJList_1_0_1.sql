-- ##Title web-服务主管操作管理-服务主管业绩管理-购方/供方对接业绩管理-服务免费-资金资源需求-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-20
-- ##Describe 查询当前服务主管的业绩列表,求和与服务主管关联的corder的服务定价基数(unit_fee),按corder的验收通过时间的年份和月度分组统计,按验收通过倒序
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t2的服务主管guid是入参目标用户id,cdr的收取服务费是免费,品类类型是资金资源需求
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2,coz_order corder,coz_demand_request cdr
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output year char[4] 2023;年度
-- ##output month char[2] 05;月份
-- ##output orderFee string[15] 1500.50;采购服务费用,保留两位小数

select 
left(acceptTime,4) as year
,right(acceptTime,2) as month
,orderFee
from
(
select 
left(t3.accept_time, 7) as acceptTime
,sum(CAST((t3.unit_fee/100) AS decimal(18,2))) as orderFee
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_server3_cate_dealstatus_statistic_outcome t2
on t1.guid = t2.statistic_guid
inner join
coz_order t3
on t1.biz_guid = t3.guid
inner join
coz_demand_request t4
on t4.guid = t3.request_guid
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
  and t4.del_flag = '0'
  and t1.dstatus in (220, 322)
  and t3.accept_status = '1'
  and t4.done_flag = '1'
  and (t2.cat_tree_code = '{catTreeCode}')
  and t2.sys_user_guid = '{targetUserId}'
  and t4.serve_fee_flag='0' and t1.cattype_guid='43cabc5d-f1ce-11ec-bace-0242ac120003'
group by left(t3.accept_time, 7)
)t
order by acceptTime desc
Limit {compute:[({page}-1)*{size}]/compute},{size};