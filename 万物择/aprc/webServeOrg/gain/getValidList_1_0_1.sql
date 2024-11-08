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
t1.guid as objectUserId
,t1.object_name as userName
,t3.nation
,t1.object_phonenumber as phonenumber
,t2.name as cattypeName
,left(t1.create_time,16) as createTime
,(select count(1) from coz_serve_order_kpi where demand_seorg_glog_guid=t1.guid and del_flag=''0'') as orderNum
from
coz_serve_org_gain_log t1
inner join
coz_cattype_fixed_data t2
on t1.cattype_guid=t2.guid
inner join
coz_app_phonenumber t3
on t1.object_phonenumber=t3.phonenumber
where t1.del_flag=''0'' and t2.del_flag=''0'' and t3.del_flag=''0'' and t1.seorg_guid=''{curUserId}'' and (t1.object_name like ''%{phonenumber}%'' or t1.object_phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t1.id desc,t2.create_time
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

