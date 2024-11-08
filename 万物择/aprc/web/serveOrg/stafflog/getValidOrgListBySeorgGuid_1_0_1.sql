-- ##Title web-查询服务权限成果-供应对接机构列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询服务权限成果-供应对接机构列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input orgName string[50] NULL;供应机构名称(模糊搜索)，非必填
-- ##input seorgGuid char[36] NOTNULL;结算机构guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t4.name as orgName
,left(t2.create_time,16) as registerTime
,left(t1.create_time,16) as relateTime
from
coz_serve_org_relate_suorg t1
inner join
coz_serve_org_relate_staff_log t2
on t1.seorg_stalog_guid=t2.guid
inner join
coz_org_relate_staff_log t3
on t1.org_stalog_guid=t3.guid
inner join
coz_org_info t4
on t3.org_user_id=t4.user_id
where
t2.seorg_guid=''{seorgGuid}'' and t1.detach_flag=''0'' and t2.detach_flag=''0'' and t3.detach_flag=''0'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and (t4.name like ''%{orgName}%'' or ''{orgName}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;