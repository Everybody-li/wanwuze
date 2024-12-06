
set @updateby=uuid()
;
update coz_serve_user_gain_log t
set
takeback_flag='1'
,takeback_time=now()
,takeback_by='0'
,takeback_type='1'
,update_time=now()
,update_by=@updateby
where
exists(
select 
1
from
coz_serve_org_gain_log t3
left join
coz_serve_order_kpi t6
on t3.guid=t6.demand_seorg_glog_guid and (t6.create_time between t3.create_time and date_add(t3.create_time,INTERVAL 90 DAY))
where t3.takeback_flag='0' and (t6.guid is null and (now()> date_add(t3.create_time,INTERVAL 90 DAY))) and t3.guid=t.seorg_glog_guid
)
;
update coz_serve_org_gain_log t
set
takeback_flag='1'
,takeback_time=now()
,takeback_by='0'
,takeback_type='1'
,update_by=@updateby
,update_time=now()
where 
exists(select 1 from coz_serve_user_gain_log where update_by=@updateby and seorg_glog_guid=t.guid)
;
delete from coz_serve_user_gain_valid t where exists(select 1 from coz_serve_user_gain_log where update_by=@updateby and seorg_glog_guid=t.seorg_glog_guid)
;
delete from coz_serve_org_gain_valid t where exists(select 1 from coz_serve_org_gain_log where update_by=@updateby and t.cattype_guid=cattype_guid and object_phonenumber=t.object_phonenumber)