-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-非二维码-查看详情(订单验收通过)-列表上方括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的非二维码成果: 某一月份的绑定该服务专员的需方/供方的订单验收通过数量,按服务专员分组统计,统计t1的数量,按t1主键去重
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input djUserGuid char[36] NOTNULL;服务专员用户id
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input orderNo string[30] NULL;采购编号(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] 10;数量

select
count(1) as totalNum
from
(
select 
cds.guid
from coz_server3_cate_dealstatus_statistic cds
         inner join coz_server3_cate_dealstatus_statistic_outcome cdso on cds.guid = cdso.statistic_guid
         inner join coz_order corder on cds.biz_guid = corder.guid
         inner join coz_demand_request cdr on corder.request_guid = cdr.guid
         inner join coz_cattype_sd_path sdPath on cds.sd_path_guid = sdPath.guid
         inner join coz_lgcode_fixed_data lfd on sdPath.lgcode_guid = lfd.guid
         inner join coz_org_info coi on cds.supply_user_id = coi.user_id
where cds.dstatus in (220, 322)
  and corder.accept_status = '1'
  and cdr.done_flag = '1'
  and (('{catTreeCode}' = 'demand' and cds.demand_sys_user_guid = '{djUserGuid}') or
       ('{catTreeCode}' = 'supply' and cds.supply_sys_user_guid = '{djUserGuid}'))
  and cdso.sys_user_guid = '{targetUserId}'
  and left(corder.accept_time, 7) = '{month}' {dynamic:orderNo[and corder.order_no like'%{orderNo}%']/dynamic}
	group by cds.guid
	)t
