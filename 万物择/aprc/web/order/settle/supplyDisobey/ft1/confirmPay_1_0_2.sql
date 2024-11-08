-- ##Title web-结算管理-确认处罚收取
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-结算管理-确认处罚收取
-- ##CallType[ExSql]

-- ##input judgeFeeGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @pay_type='',@user_type=''
;
select 
t2.pay_type,t1.user_type into @pay_type,@user_type 
from 
coz_order_judge t1 
inner join 
coz_order_judge_fee t2 
on t1.guid=t2.judge_guid 
where 
t2.guid='{judgeFeeGuid}'
;
set @flag1=(select case when (@pay_type='0' and @user_type='1') then '0' else '1' end)
;
set @flag2=(select case when (@pay_type='0' and @user_type='2') then '0' else '1' end)
;
update coz_order_judge_fee
set 
update_by='{curUserId}'
,confirm_pay_time=now()
,confirm_pay_flag='2'
,update_by='{curUserId}'
,update_time=now()
,pay_time=now()
,pay_status=3
,pay_type=3
where guid='{judgeFeeGuid}' and @flag1='1' and @flag2='1'
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '需方还未进行线上违约缴纳，无法确认处罚' when(@flag2='0') then '供方还未进行线上违约缴纳，无法确认处罚' else '操作成功' end as msg