-- ##Title web-查询服务机构招募管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务机构招募管理列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input seorgName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t1.guid as seorgStalogST3Guid
,t2.guid as seorgGuid
,t2.user_name as seorgName
,left(t2.create_time,16) as registerTime
,left(t1.create_time,16) as relateTime
,(select count(1) from coz_serve_order_kpi where demand_seorg_stalog_st3_guid=t1.guid and del_flag=''0'') as demandOrderNum
,(select count(1) from coz_serve_order_kpi where supply_seorg_stalog_st3_guid=t1.guid and del_flag=''0'') as supplyOrderNum
from
coz_serve_org_relate_staff_log t1
inner join
coz_serve_org t2
on t1.seorg_guid=t2.guid
where
t1.staff_type=''3'' and t1.detach_flag=''0'' and t1.staff_user_id=''{curUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;