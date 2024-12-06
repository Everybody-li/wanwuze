-- ##Title web-查询供应专员的权限供应机构列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供应专员的权限供应机构列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input staffUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input phonenumber string[11] NULL;品类名称，非必填


select
count(1) as count
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
where t.del_flag='0' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t1.user_id='{staffUserId}' and (t.object_name like '%{phonenumber}%' or t.object_phonenumber like '%{phonenumber}%' or '{phonenumber}'='')


