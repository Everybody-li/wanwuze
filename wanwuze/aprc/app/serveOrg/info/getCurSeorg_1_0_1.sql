-- ##Title app-查询当前所绑定的结算机构
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询当前所绑定的结算机构
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t2.guid as seorgStalogST1Guid
,t2.staff_user_id as reStaffGuid
,t1.guid as seorgGuid
,t1.user_name as orgName
,left(t2.create_time,16) as relateTime
,case when(exists(select 1 from coz_serve_org_category where seorg_guid=t2.seorg_guid)) then '1' else '0' end as hasGrantCat
from 
coz_serve_org t1
inner join
coz_serve_org_relate_staff_log t2
on t1.guid=t2.seorg_guid
where t2.staff_user_id='{curUserId}' and t2.staff_type='1' and t1.del_flag='0' and t2.del_flag='0' and t2.detach_flag='0' 