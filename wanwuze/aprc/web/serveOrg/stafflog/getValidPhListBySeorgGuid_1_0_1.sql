-- ##Title web-查询服务权限成果-服务权限对象列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询服务权限成果-服务权限对象列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NULL;服务对象手机号，必填
-- ##input seorgGuid char[36] NOTNULL;结算机构guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t1.object_name as userName
,t1.object_phonenumber as phonenumber
,t3.name as cattypeName
,left(t1.create_time,16) as gainTime
,t2.nation
from
coz_serve_org_gain_valid t1
inner join
coz_app_phonenumber t2
on t1.object_phonenumber=t2.phonenumber
inner join
coz_cattype_fixed_data t3
on t1.cattype_guid=t3.guid
where
t1.seorg_guid=''{seorgGuid}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and (t1.object_phonenumber like ''%{phonenumber}%'' or t1.object_name like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;