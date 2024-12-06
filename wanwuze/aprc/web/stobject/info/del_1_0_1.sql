-- ##Title web-删除用户
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除用户
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NOTNULL;机构专属码，必填
-- ##input objectGuid char[36] NOTNULL;机构专属码，必填


set @flag1=(select case when (exists(select 1 from sys_app_user where (status='1' or del_flag='2') and phonenumber='{phonenumber}') and not exists(select 1 from sys_app_user where (del_flag='0') and phonenumber='{phonenumber}')) then '0' else '1' end)
;
set @flag2=(select case when ((
select
sum(num1+num2+num3)
from
(
select
(select count(1) from coz_order t2 left join coz_order_fee_settle t3 on t2.guid=t3.order_guid left join coz_order_judge t4 on t2.guid=t4.order_guid where (t3.guid is null and t2.accept_way='0'  and t2.demand_user_id='{curUserId}' and t4.guid is null) 
or (t3.guid is not null and t2.accept_status='1' and t2.demand_user_id='{curUserId}' and t3.pay_type='0')) as num1
,(select count(1) from coz_order t2 inner join coz_order_judge t4 on t2.guid=t4.order_guid where t2.demand_user_id='{curUserId}' and t4.result='0') as num2
,(select count(1) from coz_order t2 inner join coz_order_judge t4 on t2.guid=t4.order_guid inner join coz_order_judge_fee t5 on t4.guid=t5.judge_guid where t2.demand_user_id='{curUserId}' and t5.confirm_pay_flag='1') as num3
)t
)>0) then '0' else '1' end)
;
update sys_app_user
set del_flag='2'
,status='1'
,update_by='{curUserId}'
,update_time=now()
where phonenumber='{phonenumber}' and @flag1='1' and @flag2='1'
;
update coz_target_object t6
left join
coz_target_object_org t7
on t7.object_guid=t6.guid
left join
coz_target_object_profile t8
on t8.object_guid=t6.guid
left join
coz_target_object_profile_filed t9
on t9.profile_guid=t8.guid
set t6.del_flag='2'
,t7.del_flag='2'
,t8.del_flag='2'
,t9.del_flag='2'
,t6.update_by='{curUserId}'
,t6.update_time=now()
,t7.update_by='{curUserId}'
,t7.update_time=now()
,t8.update_by='{curUserId}'
,t8.update_time=now()
,t9.update_by='{curUserId}'
,t9.update_time=now()
where t6.guid='{objectGuid}' and @flag1='1' and @flag2='1'
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '用户已删除或已注销，无需再次操作' when(@flag2='0') then '成果交接中有订单未完成交接或者费用结算管理中有订单的费用未完结。暂时不能删除用户。' else '操作成功' end as msg