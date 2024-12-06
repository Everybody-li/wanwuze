-- ##Title web-对接专员操作管理-购方对接业绩管理-交易规则-服务免费-非资金资源需求/资金资源需求-产品费用月度详情/方案金额月份详情-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类订单采购服务费用,按验收月份分组求和,t1.业务guid=t2.guid
-- ##Describe 若入参zjFlag=0,则出参totalSupplyFee取t2.total_fee,若入参zjFlag=1,则出参totalSupplyFee取t2.unit_fee
-- ##Describe 若入参zjFlag=0,则t4.name<>资金资源需求,若入参zjFlag=1,则t4.name=资金资源需求
-- ##Describe 其他过滤条件:t1.状态是订单验收通过,t3.收取服务费=免费
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t2,coz_demand_request t3,coz_org_info t3,coz_org_info_lgcode t4,coz_lgcode_fixed_data t5,coz_org_info t6
-- ##CallType[QueryData]


-- ##input operationMonth char[7] NOTNULL;计酬月份:2023-12
-- ##input zjType enum[0,1] NOTNULL;是否是资金资源需求:0-否,1-是
-- ##input targetUserType string[1] NULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId string[36] NULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input orgName string[50] NULL;机构名称，模糊搜索
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orgUserId decimal[>=0] 10;机构(渠道/供方)用户id
-- ##output totalFee decimal[>=0] 10;产品费用/方案金额
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output totalNum int[>=0] 10;办理申请点击

-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select
orgUserId
,sum(cast(totalFee/100 as decimal(18,2))) as totalFee
,orgID
,createTime
,supplySystem
,orgName
,phonenumber
,count(1) as totalNum
from
(
select 
t4.user_id as orgUserId
,case when ('{zjType}'='0') then t3.total_fee else t3.unit_fee end as totalFee
,t4.org_ID as orgID
,left(t4.create_time,19) as createTime
,(select a.login_sysname from coz_lgcode_fixed_data a where a.guid=t2.lgcode_guid and a.del_flag='0') as supplySystem
,t4.name as orgName
,concat('(+86)',t4.phonenumber) as phonenumber
from 
coz_server3_cate_dealstatus_statistic t1
left join
coz_cattype_sd_path t2
on t1.sd_path_guid=t2.guid
inner join
coz_order t3
on t1.biz_guid=t3.guid
inner join
coz_org_info t4
on t3.supply_user_id=t4.user_id
inner join
coz_demand_request t5
on t5.guid=t3.request_guid
where t1.del_flag='0' 
and t3.del_flag='0' 
and t4.del_flag='0' 
and t3.accept_status='1'
and (t4.name like '%{orgName}%' or '{orgName}'='')
and t5.serve_fee_flag='0'
and left(t3.accept_time,7)='{operationMonth}'
and(('{zjType}'='1' and t5.cattype_guid='43cabc5d-f1ce-11ec-bace-0242ac120003') or ('{zjType}'='0' and t5.cattype_guid<>'43cabc5d-f1ce-11ec-bace-0242ac120003'))
and (('{targetUserType}'='' and '{targetUserId}'='') or ('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}') or ('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}') or ('{targetUserType}'='3' and t1.category_guid='{targetUserId}'))
and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t3.accept_time >= @bindTime))
)t
group by orgUserId,orgID,createTime,supplySystem,orgName,phonenumber
order by createTime
Limit {compute:[({page}-1)*{size}]/compute},{size};



