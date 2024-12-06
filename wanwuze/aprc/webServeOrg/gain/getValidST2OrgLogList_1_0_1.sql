-- ##Title web-查询供应机构变动记录列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应机构变动记录列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;服务对象姓名或手机号(模糊搜索)，非必填
-- ##input phonenumber string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
from
(
select
''领取'' as statusStr
,left(t4.create_time,16) as opreaTime
,left(t1.create_time,16) as createTime
,t4.name as userName
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
where t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t2.detach_flag=''0'' and t1.seorg_guid=''{curUserId}'' and (t4.name like ''%{phonenumber}%'' or t4.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
union all
select
''收回'' as statusStr
,left(t4.create_time,16) as opreaTime
,left(t1.detach_time,16) as createTime
,t4.name as userName
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
where t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t4.del_flag=''0'' and t2.detach_flag=''1'' and t1.seorg_guid=''{curUserId}'' and (t4.name like ''%{phonenumber}%'' or t4.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
)t
order by createTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

