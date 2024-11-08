-- ##Title app-查询系统用户列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询系统用户列表
-- ##CallType[QueryData]

-- ##input seorgGuid char[36] NOTNULL;结算机构guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NULL;手机号或姓名(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t4.seorg_stalog_st1_guid as seorgStalogST1Guid
,t4.seorg_glog_guid as seorgGlogGuid
,t2.name as userName
,t2.nation
,t2.phonenumber
,t1.name as cattypeName
,t1.guid as cattypeGuid
from
(
select
*
from
coz_cattype_fixed_data t
where
exists (select 1 from coz_serve_org_category where seorg_guid=''{seorgGuid}'' and del_flag=''0'' and cattype_guid=t.guid) and del_flag=''0'' and mode=''2''
) t1
left join
coz_app_phonenumber t2
on 1=1
left join
(
select a.* from coz_serve_org_gain_log a
right join
(select cattype_guid,object_phonenumber,max(id) as MID from coz_serve_org_gain_log group by cattype_guid,object_phonenumber) b
on 
a.id=b.MID
)t3
on t2.phonenumber=t3.object_phonenumber and t1.guid=t3.cattype_guid
left join
coz_serve_user_gain_valid t4
on t3.guid=t4.seorg_glog_guid
where
t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.phonenumber like ''%{phonenumber}%'' or t2.name like ''%{phonenumber}%'' or''{phonenumber}''='''') and
(t3.guid is null or (t3.guid is not null and t3.free_flag=''1'')) and t4.guid is null
order by t2.id desc,t1.create_time
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;