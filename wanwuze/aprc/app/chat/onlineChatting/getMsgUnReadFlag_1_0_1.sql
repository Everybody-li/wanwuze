-- ##Title app-应聘/招聘-面试沟通通道-我是应聘/招聘红点标志_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-应聘/招聘-面试沟通通道-我是应聘/招聘红点标志_1_0_1
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
case when exists(select 1 from coz_chat_msg t inner join coz_chat_friend t1 on t.friend_guid=t1.guid where t.to_user_id='{curUserId}' and t.read_flag='0' and t.del_flag='0' and t1.demand_user_id='{curUserId}') then '1' else '0' end deUnReadFlag
,case when exists(select 1 from coz_chat_msg t inner join coz_chat_friend t1 on t.friend_guid=t1.guid where t.to_user_id='{curUserId}' and t.read_flag='0' and t.del_flag='0' and t1.supply_user_id='{curUserId}') then '1' else '0' end suUnReadFlag