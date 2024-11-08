-- ##Title web-查询服务机构-服务专员团队列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询服务机构-服务专员团队列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NULL;服务对象手机号，必填
-- ##input seorgGuid char[36] NOTNULL;结算机构guid，必填



select
count(1) as total
from
coz_serve_org_relate_staff t1
inner join
sys_app_user t2
on t1.staff_user_id=t2.guid
where
t1.seorg_guid='{seorgGuid}' and t1.staff_type='1' and t1.del_flag='0' and t2.del_flag='0' and (t2.user_name like '%{phonenumber}%' or t2.phonenumber like '%{phonenumber}%' or '{phonenumber}'='')

