-- ##Title web-查询服务对象用户管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务对象用户管理列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input phonenumber string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
left(t2.create_time,16) as seAndSuRelateTime
,left(t4.create_time,16) as registerTime
,t3.org_user_id as orgUserId
,t4.name as userName
,(select count(1) from coz_serve_order_kpi where supply_org_stalog_st2_guid=t3.guid and supply_seorg_stalog_st2_guid=t1.guid and del_flag=''0'') as orderNum
from
coz_serve_org_relate_staff_log t1
inner join
coz_serve_org_relate_suorg t2
on t1.guid=t2.seorg_stalog_guid
inner join
coz_org_relate_staff_log t3
on t3.guid=t2.org_stalog_guid
inner join
coz_org_info t4
on t3.org_user_id=t4.user_id
where t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t1.detach_flag=''0'' and t3.detach_flag=''0'' and t1.seorg_guid=''{curUserId}''  and (t4.name like ''%{phonenumber}%'' or t4.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

