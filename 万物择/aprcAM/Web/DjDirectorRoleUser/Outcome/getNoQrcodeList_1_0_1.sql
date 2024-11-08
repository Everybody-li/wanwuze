-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-非二维码-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的非二维码成果列表,统计t1的数量,按t1主键去重,按统计时间倒序
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output month char[19] 2023-12;统计时间,月份
-- ##output totalNum int[>=0] 1;订单验收通过数量

select 
left(corder.create_time,7) as month
,count(1) as totalNum
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
  and (cdso.cat_tree_code = '{catTreeCode}')
  and cdso.sys_user_guid = '{targetUserId}'
  group by left(corder.create_time,7)
  order by left(corder.create_time,7)
Limit {compute:[({page}-1)*{size}]/compute},{size};