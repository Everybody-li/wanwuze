-- ##Title app-查看面试沟通通道红点标志_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查看面试沟通通道红点标志_1_0_1
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
case when exists(select 1 from coz_chat_msg where to_user_id='{curUserId}' and read_flag='0' and del_flag='0') then '1' else '0' end as unReadFlag