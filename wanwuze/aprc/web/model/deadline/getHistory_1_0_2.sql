-- ##Title web-查询变更记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询变更记录
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
t1.category_guid as categoryGuid
,t2.name as categoryName
,t.day
,left(t.create_time,10) as createTime
,t3.user_name as userName
,t3.nick_name as nickName
,t3.phonenumber
from
coz_category_deal_deadline_log t
left join
coz_category_deal_deadline t1
on t.deadline_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
left join
sys_user t3
on t3.user_id=t.create_by
where t1.category_guid=''{categoryGuid}''
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;