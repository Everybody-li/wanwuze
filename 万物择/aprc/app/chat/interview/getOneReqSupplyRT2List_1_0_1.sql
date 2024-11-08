-- ##Title app-应聘-查询用户某个投递等待的应聘需求投递的所有招聘方列表详情-投递记录列表(下半部分)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-应聘-查询用户某个投递等待的应聘需求投递的所有招聘方列表详情-投递记录列表(下半部分)
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;应聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

update coz_chat_demand_request_supply
set deuser_read_flag='1'
,update_by='{curUserId}'
,update_time=now()
where 
de_request_guid='{deRequestGuid}'
;
PREPARE q1 FROM '
select
t.guid as requestSupplyGuid
,t.recruit_user_id as supplyUserId
,t.recruit_user_name as supplyUserName
,t.recruit_user_phone as supplyUserPhone
,t.recruit_guid as recruitGuid
,t.recruit_reimg as supplyUserResumeImg
,left(t1.create_time,16) as sendResmTime
,t1.status as applyFriStatus
from
coz_chat_demand_request_supply t
left join
coz_chat_friend_apply t1
on t.guid=t1.request_supply_guid
where 
t.de_request_guid=''{deRequestGuid}'' and t.del_flag=''0'' and t.recommend_type=''2'' and (t1.guid is null or t1.user_id=''{curUserId}'') 
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;