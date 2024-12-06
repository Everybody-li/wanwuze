-- ##Title app-应聘方-应聘投递-投递等待时的投递
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-应聘方-应聘投递-投递等待时的投递
-- ##CallType[ExSql]

-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input requestSupplyGuid char[36] NOTNULL;需求招聘guid，必填
-- ##input userId char[36] NOTNULL;招聘方用户id，必填
-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input categoryName string[500] NOTNULL;品类名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_chat_demand_request_supply
set send_resume_flag='1'
,update_by='{curUserId}'
,update_time=now()
where guid='{requestSupplyGuid}'
;
insert into coz_chat_friend_apply (guid,cat_tree_code,user_id,target_user_id,recruit_guid,request_supply_guid,category_guid,category_name,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'demand' as catTreeCode
,'{curUserId}' as userId
,'{userId}' as supplyUserId
,'{recruitGuid}' as recruitGuid
,'{requestSupplyGuid}' as request_supply_guid
,'{categoryGuid}' as category_guid
,'{categoryName}' as category_name
,'0' as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now() as update_time
from
sys_app_user
where
guid='{curUserId}' and not exists(select 1 from coz_chat_friend_apply where user_id='{curUserId}' and target_user_id='{userId}' and  recruit_guid='{recruitGuid}')
;