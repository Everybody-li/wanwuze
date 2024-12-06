-- ##Title web-系统替需方通过验收_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-系统替需方通过验收_1_0_1
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId char[36] NOTNULL;登录用户id，必填
-- ##input acceptStatus char[1] NOTNULL;需方验收状态(1：验收通过，2：验收不通过)，必填
-- ##input bizRuleType2 char[36] NOTNULL;品类验收规则guid，必填

set @parent_guid=(select parent_guid from coz_order where guid='{orderGuid}')
;
set @flag1=(select case when not exists (select 1 from coz_order where (guid=@parent_guid) and supply_done_flag='0' and accept_way<>'0') then '1' else '0' end)
;
set @flag2=(select case when exists (select 1 from coz_order a where guid='{orderGuid}' and not exists(select 1 from coz_order_judge where order_guid='{orderGuid}' and del_flag='0' and result<>'3') and TIMESTAMPDIFF(DAY,NOW(),accept_deadline)>=0) then '1' else '0' end)
;
set @phonenumber=(select phonenumber from sys_app_user where guid='{curUserId}')
;
set @categoryGuid='',@cattypeGuid='',@categoryName='',@cattypename='',@demand_seorg_glog_guid='',@demand_seorg_guid='',@demand_gauser_id='',@demand_seorg_stalog_st1_guid='',@demand_seorg_stalog_st3_guid='',@demand_st3_user_id='',@supply_seorg_stalog_st2_guid='',@supply_seorg_guid='',@supply_gauser_id='',@supply_org_stalog_st2_guid='',@supply_seorg_stalog_st3_guid='',@supply_st3_user_id='',@supply_org_stalog_st2_guid1='',@supply_gauser_id1=''
;
select t5.category_guid,t5.cattype_guid,t5.category_name,t5.cattype_name into @categoryGuid,@cattypeGuid,@categoryName,@cattypename
from 
coz_demand_request t5
inner join 
coz_order t2 
on t5.guid = t2.request_guid
where t2.guid ='{orderGuid}'and t2.del_flag = '0' and t5.del_flag = '0'
;
set @flag3=(select case when exists (select 1 from coz_serve_org_category where category_guid=CAST(@categoryGuid AS char CHARACTER SET utf8) and del_flag = '0') then '1' else '0' end)
;
select t9.guid, t9.seorg_guid, t10.user_id, t11.guid into @demand_seorg_glog_guid,@demand_seorg_guid,@demand_gauser_id,@demand_seorg_stalog_st1_guid
from coz_serve_org_gain_log t9
left join coz_serve_user_gain_log t10
on t9.guid = t10.seorg_glog_guid and t10.takeback_flag = '0' and t10.del_flag = '0'
left join coz_serve_org_relate_staff_log t11
on t10.seorg_stalog_st1_guid = t11.guid and t11.staff_type = '1' and t11.detach_flag = '0' and
t11.del_flag = '0'
where t9.del_flag = '0'
and t9.object_phonenumber=CAST(@phonenumber AS char CHARACTER SET utf8)
and t9.cattype_guid =CAST(@cattypeGuid AS char CHARACTER SET utf8) and @flag3='1'
order by t9.id desc limit 1
;
select t12.staff_user_id,t12.guid into @supply_gauser_id1,@supply_org_stalog_st2_guid1
from 
coz_org_relate_staff_log t12
where org_user_id=(select supply_user_id from coz_order where guid='{orderGuid}') and t12.detach_flag = '0' and t12.del_flag='0'  and @flag3='0'
;
select t11.guid,t11.seorg_guid,t12.staff_user_id,t12.guid into @supply_seorg_stalog_st2_guid,@supply_seorg_guid,@supply_gauser_id,@supply_org_stalog_st2_guid
from 
coz_org_relate_staff_log t12
left join 
coz_serve_org_relate_suorg t13
on t12.guid=t13.org_stalog_guid and t13.del_flag='0'and t12.del_flag='0' and t12.detach_flag = '0'
left join
coz_serve_org_relate_staff_log t11
on t13.seorg_stalog_guid=t11.guid and t11.staff_type='2' and t11.detach_flag='0' and t11.del_flag='0'
where t12.del_flag='0' and t12.detach_flag='0' and t12.org_user_id=(select supply_user_id from coz_order where guid='{orderGuid}') and @flag3='1'
;
select t11.guid,t11.staff_user_id into @demand_seorg_stalog_st3_guid,@demand_st3_user_id
from 
coz_serve_org_relate_staff_log t11
where t11.del_flag='0' and t11.seorg_guid=CAST(@demand_seorg_guid AS char CHARACTER SET utf8) and t11.staff_type='3' and t11.detach_flag='0' and @flag3='1'
; 
select t11.guid,t11.staff_user_id into @supply_seorg_stalog_st3_guid,@supply_st3_user_id
from 
coz_serve_org_relate_staff_log t11
where t11.del_flag='0' and t11.seorg_guid=CAST(@supply_seorg_guid AS char CHARACTER SET utf8) and t11.staff_type='3' and t11.detach_flag='0' and @flag3='1'
;
insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,t.guid
,ifnull((select status from coz_order_operation_log where order_guid=t.guid order by create_time desc limit 1),'0')
,'5'
,'1'
,''
,'{curUserId}'
,now()
from
coz_order t
where (guid='{orderGuid}' or parent_guid='{orderGuid}' or guid=@parent_guid) and @flag1='1' and @flag2='1'
;
insert into coz_order_fee_settle(guid,order_guid,type,fee,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{orderGuid}'
,'1'
,supply_fee
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_order t
where (guid='{orderGuid}' or parent_guid='{orderGuid}' or guid=@parent_guid) and @flag1='1' and @flag2='1' and supply_fee>0
;
update coz_order
set accept_way='2'
,accept_status='1'
,accept_time=now()
,biz_rule_type2=(select guid from coz_order_bussiness_rule where type = 2)
,update_by='{curUserId}'
,update_time=now()
where (guid='{orderGuid}') and @flag1='1' and @flag2='1'
;
insert into coz_serve_order_kpi
(
guid
,order_guid
,cattype_guid
,cattype_name
,category_guid
,category_name
,demand_user_id
,demand_seorg_glog_guid
,demand_seorg_guid
,demand_gauser_id
,demand_seorg_stalog_st1_guid
,demand_seorg_stalog_st3_guid
,demand_st3_user_id
,supply_user_id
,supply_gauser_id
,supply_org_stalog_st2_guid
,supply_seorg_guid
,supply_seorg_stalog_st2_guid
,supply_seorg_stalog_st3_guid
,supply_st3_user_id
,money
,year
,month
,del_flag
,create_by
,create_time
,update_by
,update_time)
select
uuid() as guid
,'{orderGuid}' as order_guid
,@cattypeGuid as cattype_guid
,@cattypename as cattype_name
,@categoryGuid as category_guid
,@categoryName as category_name
,demand_user_id
,@demand_seorg_glog_guid as demand_seorg_glog_guid
,@demand_seorg_guid as demand_seorg_guid
,@demand_gauser_id as demand_gauser_id
,@demand_seorg_stalog_st1_guid as demand_seorg_stalog_st1_guid
,@demand_seorg_stalog_st3_guid as demand_seorg_stalog_st3_guid
,@demand_st3_user_id as demand_st3_user_id
,supply_user_id
,case when(@flag3='1') then @supply_gauser_id else @supply_gauser_id1 end as supply_gauser_id
,case when(@flag3='1') then @supply_org_stalog_st2_guid else @supply_org_stalog_st2_guid1 end as supply_org_stalog_st2_guid
,@supply_seorg_guid as supply_seorg_guid
,@supply_seorg_stalog_st2_guid as supply_seorg_stalog_st2_guid
,@supply_seorg_stalog_st3_guid as supply_seorg_stalog_st3_guid
,@supply_st3_user_id as supply_st3_user_id
,demand_service_fee as money
,left(now(),4) as year
,right(left(now(),7),2) as month
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_order t
where guid='{orderGuid}' and @flag1='1' and @flag2='1'