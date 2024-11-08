-- ##Title 需求-查询开启接收消息通知的供方_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-查询开启接收消息通知的供方_1_0_1
-- ##CallType[QueryData]

-- ##input userId string[2000] NOTNULL;供方用户guid(可能会有多个)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t.user_id as userId 
from
coz_supplier_notice_setting t
where t.user_id in ({userId}) and del_flag='0' and receive_flag='1'

