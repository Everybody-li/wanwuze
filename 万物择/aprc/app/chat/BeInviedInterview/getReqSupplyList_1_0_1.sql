-- ##Title app-应聘-应聘进展管理-受邀信息接收-受邀记录管理-查看工作需求受邀记录-受邀记录列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-应聘-查询某个应聘信息的投递记录
-- ##CallType[QueryData]

-- ##input recruitGuid char[36] NOTNULL;应聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output userId char[36] t1.应聘方用户id;
-- ##output userName string[50] 应聘方用户姓名;
-- ##output sendResmTime string[16] 投递日期(0000-00-00 00:00);
-- ##output applyFriStatus string[1] 1;加好友状态(0：申请中，1：通过，2：拒绝);
-- ##output applyReactTime string[16] t3的加好友的响应时间(格式：0000-00-00 00:00);
-- ##output applyGuid char[36] 好友申请Guid;

update coz_chat_supply_request_demand
set recruit_read_flag='1'
,update_by='{curUserId}'
,update_time=now()
where 
recruit_guid='{recruitGuid}'
;
PREPARE q1 FROM '
select
t1.guid as deRequestGuid
,t1.user_id as userId
,t1.user_name as userName
,left(t3.create_time,16) as sendResmTime
,t3.status as applyFriStatus
,left(t3.react_time,16) as applyReactTime
,t3.guid as applyGuid
from
coz_chat_supply_request t1
left join
coz_chat_supply_request_demand t2
on t1.guid=t2.de_request_guid
left join
coz_chat_friend_apply t3
on t2.guid=t3.request_supply_guid
where 
t2.recruit_guid=''{recruitGuid}'' and t1.del_flag=''0'' and t2.del_flag=''0''  and t3.del_flag=''0'' and t3.target_user_id=''{curUserId}'' and t2.recommend_type=''1''
order by t3.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
