-- ##Title web-服务主管操作管理-服务主管成果管理-购方用户/供方对接成果管理-非二维码-查看详情(服务专员)-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管的非二维码成果: 某一月份的绑定该服务专员的需方/供方的订单验收通过数量,按服务专员分组统计,统计t1的数量,按t1主键去重
-- ##Describe 查询条件:t1表中品类状态是验收通过,含交易模式和审批模式,t2的服务主管guid是入参目标用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_outcome t2,sys_user t3
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;月份:2023-12
-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分:demand-购方用户成果,supply-供方用户成果
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input phonenumber string[30] NULL;姓名或者联系电话(模糊搜索)

-- ##output createTime string[16] 账号开通日期;账号开通日期
-- ##output userName string[50] 账号名称;账号名称
-- ##output nickName string[50] 姓名;姓名
-- ##output phonenumber string[50] 联系电话;联系电话
-- ##output totalNum int[>=0] 1;订单验收通过数量
-- ##output djUserGuid char[36] 服务专员用户id;服务专员用户id

select t3.create_time                       as createTime,
       t3.user_name                         as userName,
       t3.nick_name                         as nickName,
       t3.phonenumber                       as phonenumber,
       t3.user_id                           as djUserGuid,
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
  and left(corder.accept_time, 7) = '{month}' and (t3.nick_name like '%{phonenumber}%' or t3.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')
	group by t3.create_time,t3.user_name,t3.nick_name,t3.phonenumber,t3.user_id
  order by corder.accept_time desc
    Limit {compute:[({page}-1)*{size}]/compute},{size};