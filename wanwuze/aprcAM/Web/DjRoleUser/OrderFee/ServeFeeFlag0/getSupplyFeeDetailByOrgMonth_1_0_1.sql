-- ##Title web-对接专员操作管理-购方对接业绩管理-交易规则-服务免费-非资金资源需求/资金资源需求-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类订单产品费用,按验收月份分组求和,t1.业务guid=t2.guid
-- ##Describe 若入参zjFlag=0,则统计t2.total_fee,若入参zjFlag=1,则统计t2.unit_fee
-- ##Describe 若入参zjFlag=0,则t4.name<>资金资源需求,若入参zjFlag=1,则t4.name=资金资源需求
-- ##Describe 其他过滤条件:t1.状态是订单验收通过,t1.品类类型=,t3.收取服务费=免费
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t2,coz_demand_request t3
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input supplyUserPhone string[50] NULL;购方信息，模糊搜索
-- ##input zjType enum[0,1] NOTNULL;是否是资金资源需求:0-否,1-是
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input targetUserType string[1] NULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId string[36] NULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalFee decimal[>=0] 10;产品费用/方案金额
-- ##output operationTime char[19] 2023-12-12 12:23:45;订单验收通过日期
-- ##output orderNo string[50] 采购编号;采购编号
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息
-- ##output demandUserPhone string[50] (+86)18650767213;购方信息

-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select 
left(t2.accept_time,19) as operationTime
,t2.order_no as orderNo
,case when ('{zjType}'='0') then cast(t2.total_fee/100 as decimal(18,2)) else cast(t2.unit_fee/100 as decimal(18,2)) end as totalFee
,t3.category_name as categoryName
,t3.cattype_name as cattypeName
,concat('(+86)',t1.supply_user_phone) as supplyUserPhone
,concat('(+86)',t3.user_phone) as demandUserPhone
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
and t3.serve_fee_flag='0'
    {dynamic:supplyUserPhone[ and t3.user_phone like '%{supplyUserPhone}%']/dynamic}
    and left(t2.accept_time,7)='{operationMonth}'
and(('{zjType}'='1' and t3.cattype_guid='43cabc5d-f1ce-11ec-bace-0242ac120003') or ('{zjType}'='0' and t3.cattype_guid<>'43cabc5d-f1ce-11ec-bace-0242ac120003'))
and (('{targetUserType}'='' and '{targetUserId}'='') or ('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}') or ('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}') or ('{targetUserType}'='3' and t1.category_guid='{targetUserId}'))
and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t3.accept_time >= @bindTime))
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



