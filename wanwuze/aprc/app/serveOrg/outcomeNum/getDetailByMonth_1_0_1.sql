-- ##Title app-按月份查询服务机构的服务成果统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-按月份查询服务机构的服务成果统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input year char[4] NOTNULL;年度，必填
-- ##input month char[2] NOTNULL;年度，必填
-- ##input seorgName string[50] NULL;领取日期(格式：0000-00-00)，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t3.user_name as seorgName
,t3.guid as seorgGuid
,t2.guid as demandSeorgStalogST1Guid
,left(t2.create_time,16) as relateTime
,left(t2.detach_time,16) as detachTime
,(select count(1) from coz_serve_order_kpi where demand_seorg_stalog_st1_guid=t2.guid and year=''{year}'' and month=''{month}'') as orderAcceptNum
from
coz_serve_org_relate_staff_log t2
inner join
coz_serve_org t3
on t2.seorg_guid=t3.guid
where
t2.staff_user_id=''{curUserId}'' and t2.del_flag=''0'' and t2.staff_type=''1''and (t3.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;