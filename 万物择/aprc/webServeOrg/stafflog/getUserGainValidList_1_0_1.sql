-- ##Title web-查询供应专员的权限供应机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员的权限供应机构列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input staffUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input phonenumber string[11] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填



PREPARE p1 FROM '
select
left(t.create_time,16) as relateTime
,t.object_name as userName
,t3.nation
,t.object_phonenumber as phonenumber
,t2.name as cattypeName
from
coz_serve_org_gain_log t
inner join
coz_serve_user_gain_valid t1
on t1.seorg_glog_guid=t.guid
inner join
coz_cattype_fixed_data t2
on t.cattype_guid=t2.guid
inner join
coz_app_phonenumber t3
on t.object_phonenumber=t3.phonenumber
where t.del_flag=''0'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t1.user_id=''{staffUserId}'' and (t.object_name like ''%{phonenumber}%'' or t.object_phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t1.id desc,t2.create_time
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

