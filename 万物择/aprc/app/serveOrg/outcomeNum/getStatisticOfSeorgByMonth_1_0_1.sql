-- ##Title app-按月份查询结算机构详情-上半部统计部分
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-按月份查询结算机构详情-上半部统计部分
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input year char[4] NOTNULL;年度，必填
-- ##input month char[2] NOTNULL;年度，必填
-- ##input demandSeorgStalogST1Guid char[36] NOTNULL;服务机构与服务专员关联记录guid，必填



select
t3.user_name as seorgName
,t3.guid as seorgGuid
,left(t2.create_time,16) as relateTime
,left(t2.detach_time,16) as detachTime
,(select count(1) from coz_serve_order_kpi where demand_seorg_stalog_st1_guid=t2.guid and year='{year}' and month='{month}') as orderAcceptNum
,'{year}' as year
,'{month}' as month
from
coz_serve_org_relate_staff_log t2
inner join
coz_serve_org t3
on t2.seorg_guid=t3.guid
where
t2.guid='{demandSeorgStalogST1Guid}' and t2.del_flag='0' and t2.staff_type='1'
