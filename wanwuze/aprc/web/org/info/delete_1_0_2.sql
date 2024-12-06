-- ##Title web-删除机构名称
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-删除机构名称
-- ##CallType[ExSql]

-- ##input orgGuid char[36] NOTNULL;机构名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @userid=(select user_id from coz_org_info where guid='{orgGuid}')
;
set @flag1=(select case when not exists(select 1 from coz_order a where supply_user_id=@userid and accept_status<>'1')  then '1' when not exists(select 1 from coz_order_judge a left join coz_order b on a.order_guid=b.guid where b.supply_user_id=@userid and a.result<>'3') then '1' else '0' end)
;
update sys_weborg_user
set 
del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid=@userid and @flag1='1'
;
update coz_org_info
set 
del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{orgGuid}' and @flag1='1'
;
select 
case when(@flag1='1') then '1' else '0' end as delFalg
,case when(@flag1='1') then concat('【',name,'】','<br />删除后，该机构的【供应结算管理】中的内容保留') else concat('【',name,'】','<br />有采购订单未完结，不能删除') end as notOkReason
from
coz_org_info
where guid='{orgGuid}'
;