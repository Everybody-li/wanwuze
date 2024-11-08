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
coz_serve_org_category_log t1
where t1.batch_no='{batchNo}' and t1.del_flag='0'

