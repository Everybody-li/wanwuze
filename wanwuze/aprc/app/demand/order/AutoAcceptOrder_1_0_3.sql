-- ##Title app-采购-系统通过验收_1_0_3
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-系统通过验收_1_0_3
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId char[36] NOTNULL;登录用户id，必填

insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,t.guid
,ifnull((select status from coz_order_operation_log where order_guid=t.guid order by create_time desc limit 1),'0')
,'5'
,'0'
,''
,'0'
,now()
from
coz_order t
where not exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag='0' and result<>'3') and t.pay_status='2' and t.accept_status='0' and t.supply_done_flag='1'  and TIMESTAMPDIFF(DAY,left(NOW(),10),t.accept_deadline)=1
;
insert into coz_order_fee_settle(guid,order_guid,type,fee,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,t.guid
,'1'
,supply_fee
,'0'
,'0'
,now()
,'0'
,now()
from
coz_order t
where not exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag='0' and result<>'3') and t.pay_status='2' and t.accept_status='0' and t.supply_done_flag='1'  and TIMESTAMPDIFF(DAY,left(NOW(),10),t.accept_deadline)=1
;
insert into coz_order_gyv2_kpi(guid,order_guid,order_no,category_guid,category_name,category_create_time,cattype_guid,cattype_name,gyv2re_stalog_guid,gyv2staff_user_id,org_user_id,serve_fee_flag,pay_time,create_time,money,year,month,day)
select
uuid()
,order_guid
,order_no
,category_guid
,category_name
,category_create_time
,cattype_guid
,cattype_name
,gyv2re_stalog_guid
,gyv2staff_user_id
,org_user_id
,serve_fee_flag
,pay_time
,now() as create_time
,case when(t.serve_fee_flag='0') then t.supply_fee else t.demand_service_fee end as money
,left(now(),4) as year
,right(left(now(),7),2) as month
,right(left(now(),10),2) as day
from
(
select
t2.guid as order_guid
,t2.order_no as order_no
,t2.category_guid as category_guid
,t6.name as category_name
,t6.create_time as category_create_time
,t6.cattype_guid as cattype_guid
,t6.cattype_name as cattype_name
,t7.guid as gyv2re_stalog_guid
,t7.staff_user_id as gyv2staff_user_id
,t7.org_user_id as org_user_id
,t8.serve_fee_flag as serve_fee_flag
,t2.pay_time as pay_time
,t2.supply_fee
,t2.demand_service_fee
from
coz_org_gyv2_relate_staff_log t7
inner join
coz_order t2
on t7.org_user_id=t2.supply_user_id
inner join
coz_demand_request t8
on t2.request_guid=t8.guid
inner join
coz_category_info t6
on t2.category_guid=t6.guid
where not exists(select 1 from coz_order_judge where order_guid=t2.guid and del_flag='0' and result<>'3') and t2.pay_status='2' and t2.accept_status='0' and t2.supply_done_flag='1'  and TIMESTAMPDIFF(DAY,left(NOW(),10),t2.accept_deadline)=1
)t
;


# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --
set @statisticBizGuidMode2 = '';
set @statisticBizGuidMode3 = '';
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @catMode = 0;

select t2.category_mode
into @catMode
from coz_order t1
         inner join coz_demand_request t2 on t1.request_guid = t2.guid
where t1.guid = '{orderGuid}';

# 查询交易模式 上一状态业务guid,订单如果仲裁过,则业务guid为仲裁guid
select t2.guid as bizGuid
into @statisticBizGuidMode2
from coz_order t1
         inner join coz_order_judge t2 on t1.guid = t2.order_guid
where t1.guid = '{orderGuid}'
  and t2.result = '4'
  and @catMode = '2';
select ifnull(@statisticBizGuidMode2, '{orderGuid}')
into @statisticBizGuidMode2
where @catMode = 2;

# 查询审批模式下上一状态业务guid
select '{orderGuid}' as bizGuid
into @statisticBizGuidMode3
where @catMode = 3;

# 查询需方用户的对接专员
select t2.user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_sys_user_dj_bind t2
     on t1.demand_user_id = t2.binded_user_id
where t1.biz_guid in (@statisticBizGuidMode2, @statisticBizGuidMode3)
  and t1.del_flag = '0'
  and t2.user_type = '1';

# 查询供方用户的对接专员
select t2.user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_sys_user_dj_bind t2
     on t1.demand_user_id = t2.binded_user_id
where t1.biz_guid in (@statisticBizGuidMode2, @statisticBizGuidMode3)
  and t1.del_flag = '0'
  and t2.user_type = '2';

# 交易模式:更新品类交易状态为订单验收通过
update coz_server3_cate_dealstatus_statistic
set dstatus             = 220
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
,update_time=now()
where biz_guid = @statisticBizGuidMode2
  and @flag1 = '1'
  and @flag2 = '1'
  and @catMode = 2
;

# 审批模式:更新品类交易状态为订单验收通过
update coz_server3_cate_dealstatus_statistic
set dstatus             = 322
,update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = @statisticBizGuidMode3
  and @flag1 = '1'
  and @flag2 = '1'
  and @catMode = 3
;
# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --

update coz_order t
set accept_way='2'
,accept_status='1'
,accept_time=now()
,biz_rule_type2=(select guid from coz_order_bussiness_rule where type = 2)
,update_by='1'
,update_time=now()
where not exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag='0' and result<>'3') and t.pay_status='2' and t.accept_status='0' and t.supply_done_flag='1'  and TIMESTAMPDIFF(DAY,left(NOW(),10),t.accept_deadline)=1
;
