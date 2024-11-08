-- ##Title app-按月份查询服务机构的服务成果统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-按月份查询服务机构的服务成果统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input year char[4] NOTNULL;年度，必填
-- ##input month char[2] NOTNULL;年度，必填
-- ##input demandSeorgStalogST1Guid char[36] NULL;领取日期
-- ##input phonenumber string[50] NULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t3.guid as userGainLogGuid
,t5.name as cattypeName
,concat(''(+86)'',t4.object_phonenumber) as phonenumber
,t4.object_name as userName
,left(t4.create_time,16) as gainTime
,(select count(1) from coz_serve_order_kpi where demand_seorg_stalog_st1_guid=t2.guid and demand_seorg_glog_guid=t4.guid and year=''{year}'' and month=''{month}'') as orderAcceptNum
,(select guid from sys_app_user where phonenumber=t4.object_phonenumber limit 1) as demandUserId
,t2.guid as demandSeorgStalogST1Guid
from
coz_serve_org_relate_staff_log t2
inner join
coz_serve_user_gain_log t3
on t2.guid=t3.seorg_stalog_st1_guid
inner join
coz_serve_org_gain_log t4
on t3.seorg_glog_guid=t4.guid
inner join
coz_cattype_fixed_data t5
on t4.cattype_guid=t5.guid
where
t2.guid=''{demandSeorgStalogST1Guid}'' and t2.del_flag=''0'' and t3.del_flag=''0''and t2.staff_type=''1''and (t4.object_phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;