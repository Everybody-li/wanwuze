-- ##Title app-查询手机好友一键领取成功数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询手机好友一键领取成功数量
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input batchNo string[36] NOTNULL;登录用户id，必填



select
count(1) as okNum
from
(
select 
1
from 
coz_serve_user_gain_log t1
inner join
coz_serve_org_gain_log t2
on t1.seorg_glog_guid=t2.guid
where t1.batch_no='{batchNo}' and t1.del_flag='0' and t2.del_flag='0'
group by t1.batch_no,t2.object_phonenumber
)t

