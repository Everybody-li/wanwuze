-- ##Title web-查询服务对象变动记录列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务对象变动记录列表
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
t.guid as seorgGlogGuid
,''领取'' as statusStr
,left(t.create_time,16) as opreaTime
,t.object_name as userName
,t2.nation
,t.object_phonenumber as phonenumber
,t1.name as cattypeName
,t.id
from
coz_serve_org_gain_log t
inner join
coz_cattype_fixed_data t1
on t.cattype_guid=t1.guid
inner join
coz_app_phonenumber t2
on t.object_phonenumber=t2.phonenumber
where t.del_flag=''0'' and t1.del_flag=''0'' and t.takeback_flag=''0'' and t.seorg_guid=''{curUserId}'' and (t.object_name like ''%{phonenumber}%'' or t.object_phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
union all
select
t.guid as seorgGlogGuid
,''收回'' as statusStr
,left(t.create_time,16) as opreaTime
,t.object_name as userName
,t2.nation
,t.object_phonenumber as phonenumber
,t1.name as cattypeName
,t.id
from
coz_serve_org_gain_log t
inner join
coz_cattype_fixed_data t1
on t.cattype_guid=t1.guid
inner join
coz_app_phonenumber t2
on t.object_phonenumber=t2.phonenumber
where t.del_flag=''0'' and t1.del_flag=''0'' and t.takeback_flag=''1'' and t.seorg_guid=''{curUserId}'' and (t.object_name like ''%{phonenumber}%'' or t.object_phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

