-- ##Title web-对接专员操作管理-购方对接业绩管理-交易规则-服务收费-年度详情-采购服务费用月度详情
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类订单采购服务费用,按验收月份分组求和,t1.业务guid=t2.guid
-- ##Describe 其他过滤条件:t1.状态是订单验收通过,只查询主订单,t3.收取服务费=收费
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t2,coz_demand_request t3
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input operationMonth char[7] NOTNULL;计酬月份:2023-12
-- ##input targetUserType string[1] NULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId string[36] NULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input supplyUserPhone string[50] NULL;购方信息或者机构名称或者机构账号ID，模糊搜索

-- ##output totalServiceFee decimal[>=0] 10;采购服务费用
-- ##output operationTime char[19] 2023-12-12 12:23:45;订单验收通过日期
-- ##output orderNo string[50] 采购编号;采购编号
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息
-- ##output orgUserId char[36] ;供应机构guid
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号


-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select 
t5.guid as orgUserId
,left(t2.accept_time,19) as operationTime
,t2.order_no as orderNo
,cast(t2.demand_service_fee/100 as decimal(18,2)) as totalServiceFee
,t3.category_name as categoryName
,t3.cattype_name as cattypeName
,concat('(+86)',t5.phonenumber) as supplyUserPhone
,t5.org_ID as orgID
,left(t5.create_time,19) as createTime
,(select a.login_sysname from coz_lgcode_fixed_data a where a.guid=t4.lgcode_guid and a.del_flag='0') as supplySystem
,t5.name as orgName
,concat('(+86)',t5.phonenumber) as phonenumber
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_order t2
on t1.biz_guid=t2.guid
inner join
coz_demand_request t3
on t3.guid=t2.request_guid
left join
coz_cattype_sd_path t4
on t1.sd_path_guid=t4.guid
left join
coz_org_info t5
on t2.supply_user_id=t5.user_id
where t1.del_flag='0' 
and t2.del_flag='0' 
and t3.del_flag='0' 
and t2.accept_status='1'
and t3.serve_fee_flag='1'
and (t2.parent_guid='' or t2.parent_guid is null)
and (t5.phonenumber like '%{supplyUserPhone}%' or t5.org_ID like '%{supplyUserPhone}%' or t5.name like '%{supplyUserPhone}%' or '{supplyUserPhone}'='')
and left(t2.accept_time,7)='{operationMonth}'
and (('{targetUserType}'='' and '{targetUserId}'='') or ('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}') or ('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}') or ('{targetUserType}'='3' and t1.category_guid='{targetUserId}'))
and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t2.accept_time >= @bindTime))
order by t2.accept_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



