-- ##Title web-服务主管操作管理-服务主管业绩管理-购方/供方对接业绩管理-服务免费-非资金资源需求-产品费用月度详情-产品费用机构详情-产品费用订单详情-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-20
-- ##Describe 查询当前服务主管的业绩列表:某一月份下,查询归属服务主管的服务专员的有订单验收通过的订单列表,,按订单验收通过时间升序,订单支付时间升序
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t1的需方/供方对接专员是入参对接专员guid,订单供方是入参机构用户id,t2的服务主管guid是入参目标用户id,cdr的收取服务费是免费,品类类型是非资金资源需求
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2,coz_order corder,coz_demand_request cdr
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input month char[7] NOTNULL;计酬月份,格式:0000-00
-- ##input djUserGuid char[36] NOTNULL;对接专员guid
-- ##input orgUserId char[36] NOTNULL;机构(供方)用户id
-- ##input phonenumber string[30] NULL;购方信息,电话(模糊搜索)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output acctpeTime string[19] 2023-12-12 12:23:45;验收通过时间
-- ##output orderNo string[30] 采购编号;采购编号
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output orderFee string[50] 采购服务费用;采购服务费用
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息

-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}


select 
left(t3.accept_time, 19) as acctpeTime
,t3.order_no as orderNo
,t4.category_name as categoryName
,t4.cattype_name as cattypeName
,CAST((t3.unit_fee/100) AS decimal(18,2)) as orderFee
,concat('(+86)',t4.user_phone) as supplyUserPhone
,concat('(+86)',t4.user_phone) as demandUserPhone
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
  and (('{catTreeCode}' = 'demand' and t1.demand_sys_user_guid = '{djUserGuid}') or
       ('{catTreeCode}' = 'supply' and t1.supply_sys_user_guid = '{djUserGuid}'))
  and t1.supply_user_id = '{orgUserId}'
  and t4.serve_fee_flag='0' and left(t3.accept_time,7)='{month}' and t1.cattype_guid<>'43cabc5d-f1ce-11ec-bace-0242ac120003' and (t4.user_phone like'%{phonenumber}%' or '{phonenumber}'='')
  and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and t3.accept_time >= @bindTime))
Limit {compute:[({page}-1)*{size}]/compute},{size};
