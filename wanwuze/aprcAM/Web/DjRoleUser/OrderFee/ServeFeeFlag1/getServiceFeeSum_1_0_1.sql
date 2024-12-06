-- ##Title web-对接专员操作管理-购方对接业绩管理-交易规则-服务收费-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类订单采购服务费用,按验收月份分组求和,t1.业务guid=t2.guid
-- ##Describe 其他过滤条件:t1.状态是订单验收通过,只查询主订单,t3.收取服务费=收费
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t2,coz_demand_request t3
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input targetUserType string[1] NULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId string[36] NULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output operationYear char[4] 2023;年度
-- ##output operationMonth char[2] 12;计酬月份
-- ##output totalFee decimal[>=0] 10;采购服务费用


-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select 
left(t2.accept_time,4) as operationYear
,right(left(t2.accept_time,7),2) as operationMonth
,sum(cast(t2.demand_service_fee/100 as decimal(18,2))) as totalFee
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_order t2
on t1.biz_guid=t2.guid
inner join
coz_demand_request t3
on t3.guid=t2.request_guid
where t1.del_flag='0' 
and t2.del_flag='0' 
and t3.del_flag='0' 
and t2.accept_status='1'
and t3.serve_fee_flag='1'
and (t2.parent_guid='' or t2.parent_guid is null)
and (
('{targetUserType}'='' and '{targetUserId}'='') or 
('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}') or 
('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}') or 
('{targetUserType}'='3' and t1.category_guid='{targetUserId}'))
and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t2.accept_time >= @bindTime))
group by operationYear,operationMonth
order by operationYear desc,operationMonth desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



