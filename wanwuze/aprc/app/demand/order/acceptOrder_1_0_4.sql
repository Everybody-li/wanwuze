-- ##Title app-采购-通过验收
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-通过验收
-- ##Describe 查出当前需方服务专员关联的服务主管,有就新增dsdo,查出供方服务专员关联的服务主管,有就新增dsdo
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic_outcome dso
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId char[36] NOTNULL;登录用户id，必填
-- ##input acceptStatus char[1] NOTNULL;需方验收状态(1：验收通过，2：验收不通过)，必填
-- ##input bizRuleType2 char[36] NOTNULL;品类验收规则guid，必填


set @parent_guid = (select parent_guid
                    from coz_order
                    where guid = '{orderGuid}')
;
set @flag1 = (select case
                         when not exists(select 1
                                         from coz_order
                                         where (guid = '{orderGuid}' or parent_guid = '{orderGuid}' or guid = @parent_guid)
                                           and supply_done_flag = '0'
                                           and accept_way <> '1') then '1'
                         else '0' end)
;
set @flag2 = (select case
                         when exists(select 1
                                     from coz_order a
                                     where guid = '{orderGuid}'
                                       and not exists(select 1
                                                      from coz_order_judge
                                                      where order_guid = '{orderGuid}'
                                                        and del_flag = '0'
                                                        and result <> '3')
                                       and TIMESTAMPDIFF(DAY, NOW(), accept_deadline) >= 0) then '1'
                         else '0' end)
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , t.guid
     , ifnull((select status from coz_order_operation_log where order_guid = t.guid order by create_time desc limit 1),
              '0')
     , '5'
     , '1'
     , ''
     , '{curUserId}'
     , now()
from coz_order t
where (guid = '{orderGuid}' or parent_guid = '{orderGuid}' or guid = @parent_guid)
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_order_fee_settle(guid, order_guid, type, fee, del_flag, create_by, create_time, update_by, update_time)
select uuid()
     , guid
     , '1'
     , supply_fee
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order t
where (guid = '{orderGuid}' or parent_guid = '{orderGuid}' or guid = @parent_guid)
  and @flag1 = '1'
  and @flag2 = '1'
  and '{acceptStatus}' = '1'
  and supply_fee > 0
;

# insert into coz_order_gyv2_kpi(guid,order_guid,order_no,category_guid,category_name,category_create_time,cattype_guid,cattype_name,gyv2re_stalog_guid,gyv2staff_user_id,org_user_id,serve_fee_flag,pay_time,create_time,money,year,month,day)
# select
# uuid()
# ,'{orderGuid}' as order_guid
# ,t2.order_no as order_no
# ,t2.category_guid as category_guid
# ,t6.name as category_name
# ,t6.create_time as category_create_time
# ,t6.cattype_guid as cattype_guid
# ,t6.cattype_name as cattype_name
# ,t7.guid as gyv2re_stalog_guid
# ,t7.staff_user_id as gyv2staff_user_id
# ,t7.org_user_id as org_user_id
# ,t8.serve_fee_flag as serve_fee_flag
# ,t2.pay_time as pay_time
# ,now() as create_time
# ,case when(t8.serve_fee_flag='0') then t2.supply_fee else t2.demand_service_fee end as money
# ,left(now(),4) as year
# ,right(left(now(),7),2) as month
# ,right(left(now(),10),2) as day
# from
# coz_org_gyv2_relate_staff_log t7
# inner join
# coz_order t2
# on t7.org_user_id=t2.supply_user_id
# inner join
# coz_demand_request t8
# on t2.request_guid=t8.guid
# inner join
# coz_category_info t6
# on t2.category_guid=t6.guid
# where t7.detach_flag='0' and t2.guid='{orderGuid}' and @flag1='1' and @flag2='1'
# ;

# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --

# 品类交易状态逻辑---开始---
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';


set @supplyUserGuid = '';
set @catMode = {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\CatDealStatus\getCatModeByOrderGuid_1_0_1&orderGuid={orderGuid}&DBC=w_a]/url};

select supply_user_id into @supplyUserGuid
from coz_order
where guid = '{orderGuid}';

# 查询需方用户的对接专员
select user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = '{curUserId}'
  and user_type = '1';

# 查询供方用户的对接专员
select user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = @supplyUserGuid
  and user_type = '2';

# 交易模式:更新品类交易状态-订单验收通过
update coz_server3_cate_dealstatus_statistic
set dstatus             = 220
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{orderGuid}' and @catMode = 2 and @flag1 = '1' and @flag2 = '1';

# 审批模式:更新品类交易状态-订单验收通过
update coz_server3_cate_dealstatus_statistic
set dstatus             = 322
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid =  '{orderGuid}' and @catMode = 3 and @flag1 = '1' and @flag2 = '1';
# 品类交易状态逻辑---结束---

# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --

# 更新订单为需方验收通过
update coz_order
set accept_way='1'
  , accept_status='{acceptStatus}'
  , accept_time=now()
  , biz_rule_type2='{bizRuleType2}'
  , update_by='{curUserId}'
  , update_time=now()
where (guid = '{orderGuid}' or guid = @parent_guid or parent_guid = '{orderGuid}')
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_server3_cate_dealstatus_statistic_outcome
( 
guid
,statistic_guid
,sys_user_guid
,cat_tree_code
,create_by
,create_time
,del_flag
)
select uuid()
     , (select guid from coz_server3_cate_dealstatus_statistic where biz_guid =  '{orderGuid}' and del_flag='0' limit 1)
     , binded_suser_guid       as sys_user_guid
     , 'demand'      as cat_tree_code
     , '{curUserId}'      as create_by
     , now()              as create_time
     , 0                  as del_flag
from
coz_server3_sys_user_bind
where
bind_suser_guid=@demandSysUserGuid and @flag1 = '1' and @flag2 = '1'
;
insert into coz_server3_cate_dealstatus_statistic_outcome
( 
guid
,statistic_guid
,sys_user_guid
,cat_tree_code
,create_by
,create_time
,del_flag
)
select uuid()
     , (select guid from coz_server3_cate_dealstatus_statistic where biz_guid =  '{orderGuid}' and del_flag='0' limit 1)
     , binded_suser_guid       as sys_user_guid
     , 'supply'      as cat_tree_code
     , '{curUserId}'      as create_by
     , now()              as create_time
     , 0                  as del_flag
from
coz_server3_sys_user_bind
where
bind_suser_guid=@supplySysUserGuid and @flag1 = '1' and @flag2 = '1'
;


