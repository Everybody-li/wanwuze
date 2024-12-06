-- ##Title web-查询登录记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询登录记录
-- ##CallType[QueryData]


-- ##input curUserId string[36] NOTNULL;登录用户id，必填


PREPARE q1 FROM '
select 
t.guid as loginLogGuid
,t.phonenumber
,left(t.create_time,16) as loginTime
from 
coz_org_user_login t
where org_user_id=''{curUserId}''
order by t.id desc
limit ?,?;
';
SET @start =((1-1)*2000);
SET @end =(2000);
EXECUTE q1 USING @start,@end;