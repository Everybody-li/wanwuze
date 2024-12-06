-- ##Title web-查询手机号更新记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询手机号更新记录
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
t.guid as phoneLogGuid
,left(t.create_time,16) as createTime
from 
coz_org_phone_log t
left join
coz_org_info t1
on t.org_guid=t1.guid
where user_id=''{curUserId}''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;