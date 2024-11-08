-- ##Title web-服务专员用户-查询服务专员成果列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务专员用户-查询服务专员成果列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input staffST1UserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input phonenumber string[50] NULL;姓名或手机号（模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
,(select count(1) from coz_serve_order_kpi where demand_user_id=t.user_id and del_flag=''0'' and demand_gauser_id=''{staffST1UserId}'') as acceptOrderNum
from
(
select
left(t.create_time,16) as registerTime
,t1.nation
,t1.phonenumber
,t1.name as userName
,t1.user_id
from
coz_app_phonenumber t1
left join 
sys_app_user t
on t1.user_id=t.guid
left join
coz_serve_org_gain_log t2
on t1.phonenumber=t2.object_phonenumber
left join
coz_serve_user_gain_log t3
on t2.guid=t3.seorg_glog_guid
where t3.user_id=''{staffST1UserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t1.name like ''%{phonenumber}%'' or t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
)t
group by t.registerTime,t.nation,t.phonenumber,t.userName,t.user_id
order by t.registerTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

