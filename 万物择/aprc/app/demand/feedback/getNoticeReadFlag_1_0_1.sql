-- ##Title 消息通知-列表内容阅读标志_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe 消息通知-列表内容阅读标志_1_0_1
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id，必填

-- ##output demandReadFlag int[>=0] 10;使用反馈内容阅读标志(0:未读，1：已读)

select
case when exists(select 1 from coz_order_notice where user_id='{curUserId}' and read_flag='0' and del_flag='0' and cat_tree_code='demand') then '0' else '1' end as demandReadFlag