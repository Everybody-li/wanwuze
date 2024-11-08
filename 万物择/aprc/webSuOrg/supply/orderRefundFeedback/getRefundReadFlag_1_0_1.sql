-- ##Title 退货退款异常反馈-列表内容阅读标志_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-06-11
-- ##Describe 退货退款异常反馈-列表内容阅读标志_1_0_1
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id，必填

-- ##output supplyReadFlag int[>=0] 10;退货退款反馈内容阅读标志(0:未读，1：已读)

select
case when exists(select 1 from coz_order_refund_feedback where user_id='{userId}' and reply_content_read_flag='1' and del_flag='0' and cat_tree_code='supply') then '0' else '1' end as supplyReadFlag