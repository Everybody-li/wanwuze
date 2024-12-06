-- ##Title app-采购-申请在线沟通
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-申请在线沟通
-- ##CallType[ExSql]

-- ##input catTreeCode string[20] NOTNULL;供需区分（demand：应聘，supply：招聘），必填
-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input supplyUserId char[36] NOTNULL;目标用户id，必填

insert into coz_chat_friend_apply (guid,cat_tree_code,user_id,target_user_id,recruit_guid,category_guid,category_name,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{catTreeCode}' as catTreeCode
,'{userId}' as userId
,'{supplyUserId}' as supplyUserId
,'{recruitGuid}' as recruitGuid
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
guid='{userId}' and not exists(select 1 from coz_chat_friend_apply where user_id='{userId}' and target_user_id='{supplyUserId}' and recruit_guid='{recruitGuid}')
