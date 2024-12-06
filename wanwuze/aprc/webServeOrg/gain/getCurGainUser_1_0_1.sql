-- ##Title web-查询服务对象的服务专员
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务对象的服务专员
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input seorgGlogGuid string[36] NULL;服务机构与服务对象绑定guid，必填


select
t1.user_name as userName
,t1.nation
,t1.phonenumber
,left(t.create_time,16) as createTime
,left(t1.create_time,16) as openingTime
from
coz_serve_user_gain_valid t
inner join
sys_app_user t1
on t.user_id=t1.guid
where t1.del_flag='0' and t.del_flag='0' and t.seorg_glog_guid='{seorgGlogGuid}'
order by t.id desc


