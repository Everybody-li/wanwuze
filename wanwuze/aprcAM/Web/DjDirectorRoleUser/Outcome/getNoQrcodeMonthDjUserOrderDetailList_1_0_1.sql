-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-非二维码-查看详情(订单验收通过)-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的非二维码成果: 某一月份的绑定该服务专员的需方/供方的订单验收通过列表
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2,coz_order t3,coz_demand_request t4,coz_cattype_sd_path t5,coz_lgcode_fixed_data t7
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input djUserGuid char[36] NOTNULL;服务专员用户id
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input orderNo string[30] NULL;采购编号(模糊搜索)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output acctpeTime string[19] 2023-12-12 12:23:45;验收通过时间
-- ##output orderNo string[30] 采购编号;采购编号
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output orgID char[18] ;供应供方-机构账号ID
-- ##output createTime char[19] 2023-12-12 12:23:45;账号开通日期
-- ##output orgName string[100] ;机构名称
-- ##output phonenumber string[100] ;机构手机号
-- ##output demandUserPhone string[50] (+86)18650767213;需方信息
-- ##output supplySystem string[50] 登录系统;登录系统

-- 取服务主管相关信息
-- {file[aprcAM/Web/DjDirectorRoleUser/GetServeSUserBindTime.txt]/file}

select corder.accept_time                     as acctpeTime,
       corder.order_no                        as orderNo,
       cdr.cattype_name                       as cattypeName,
       cdr.category_name                      as categoryName,
       coi.org_ID                             as orgID,
       coi.create_time                        as createTime,
       cds.supply_user_name                   as orgName,
       concat('(+86)', cds.supply_user_phone) as phonenumber,
       concat('(+86)', cdr.user_phone)        as demandUserPhone,
       lfd.login_sysname                      as supplySystem
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
  and (@serveDirectorFlag = 0 or (@serveDirectorFlag = 1 and corder.accept_time >= @bindTime))
	group by corder.accept_time,corder.order_no,cdr.cattype_name,cdr.category_name,coi.org_ID,coi.create_time,cds.supply_user_name,cds.supply_user_phone,cdr.user_phone,lfd.login_sysname
order by corder.accept_time desc
    Limit {compute:[({page}-1)*{size}]/compute},{size};
