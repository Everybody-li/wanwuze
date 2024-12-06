-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-非二维码-查看详情(服务专员)-列表上号括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的非二维码成果:某一月份的绑定该服务专员的需方/供方的订单验收通过数量,统计t1的数量,按t1主键去重,
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2,sys_user t3
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] 1;订单验收通过

-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select 
ifnull(sum(totalNum),0) as totalNum
from
(
select 
       count(1)                             as totalNum
from coz_server3_cate_dealstatus_statistic cds
         inner join coz_server3_cate_dealstatus_statistic_outcome cdso on cds.guid = cdso.statistic_guid
         inner join coz_order corder on cds.biz_guid = corder.guid
         inner join coz_demand_request cdr on corder.request_guid = cdr.guid
         inner join coz_cattype_sd_path sdPath on cds.sd_path_guid = sdPath.guid
         inner join coz_lgcode_fixed_data lfd on sdPath.lgcode_guid = lfd.guid
         inner join coz_org_info coi on cds.supply_user_id = coi.user_id
         inner join sys_user t3 on (('{catTreeCode}' = 'demand' and cds.demand_sys_user_guid =t3.user_id) or ('{catTreeCode}' = 'supply' and cds.supply_sys_user_guid = t3.user_id))
where cds.dstatus in (220, 322)
  and corder.accept_status = '1'
  and cdr.done_flag = '1'
  and (cdso.cat_tree_code = '{catTreeCode}')
  and cdso.sys_user_guid = '{targetUserId}'
  and left(corder.accept_time, 7) = '{month}'
  and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and corder.accept_time >= @bindTime))
  group by t3.create_time,t3.user_name,t3.nick_name,t3.phonenumber
)t