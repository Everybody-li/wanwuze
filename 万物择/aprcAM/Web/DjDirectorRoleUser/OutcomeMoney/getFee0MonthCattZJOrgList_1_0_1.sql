-- ##Title web-服务主管操作管理-服务主管业绩管理-购方/供方对接业绩管理-服务免费-资金资源需求-方案金额月份详情-方案金额机构详情-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-20
-- ##Describe 查询当前服务主管的业绩列表:某一月份下,查询归属服务主管的服务专员的有订单验收通过的供方机构列表,求和corder的服务定价基数(unit_fee),按订单供方和corder的验收通过时间的年份和月度分组求和,按机构创建时间倒序
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t1的需方/供方对接专员是入参对接专员guid,t2的服务主管guid是入参目标用户id,cdr的收取服务费是免费,品类类型是资金资源需求
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2,coz_order corder,coz_demand_request cdr,coz_org_info org
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input month char[7] NOTNULL;计酬月份,格式:0000-00
-- ##input djUserGuid char[36] NOTNULL;对接专员guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input orgName string[60] NULL;机构名称(模糊搜索)，非必填

-- ##output djUserGuid char[36] ;对接专员guid
-- ##output orgUserId int[>=0] 1;机构用户id
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output month string[7] 计酬月份;计酬月份
-- ##output orderFee string[50] 采购服务费用;采购服务费用

select
*
,'{month}' as month
from
(
select 
       t1.supply_user_id                      as orgUserId,
       t8.org_ID                              as orgID,
       t8.create_time                         as createTime,
       t1.supply_user_name                    as orgName,
       t1.supply_user_phone                   as phonenumber,
       t7.login_sysname                       as supplySystem,
       sum(CAST((t3.unit_fee/100) AS decimal(18,2))) as orderFee
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
inner join 
coz_cattype_sd_path t6
on t4.sd_path_guid = t6.guid
inner join
coz_lgcode_fixed_data t7
on t6.lgcode_guid = t7.guid
inner join 
coz_org_info t8
on t1.supply_user_id = t8.user_id
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
  and t4.del_flag = '0'
  and t1.dstatus in (220, 322)
  and t3.accept_status = '1'
  and t4.done_flag = '1'
  and (t2.cat_tree_code = '{catTreeCode}')
  and t2.sys_user_guid = '{targetUserId}'
  and (('{catTreeCode}' = 'demand' and t1.demand_sys_user_guid = '{djUserGuid}') or
       ('{catTreeCode}' = 'supply' and t1.supply_sys_user_guid = '{djUserGuid}'))
  and t4.serve_fee_flag='0' and left(t3.accept_time,7)='{month}' and t1.cattype_guid='43cabc5d-f1ce-11ec-bace-0242ac120003' and (t1.supply_user_name like'%{orgName}%' or '{orgName}'='')
group by t1.supply_user_id,t8.org_ID,t8.create_time,t1.supply_user_name,t1.supply_user_phone,t7.login_sysname
)t
order by createTime desc
Limit {compute:[({page}-1)*{size}]/compute},{size};