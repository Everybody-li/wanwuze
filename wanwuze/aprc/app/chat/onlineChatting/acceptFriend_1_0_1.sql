-- ##Title app-通过好友申请
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-申请在线沟通
-- ##CallType[ExSql]

-- ##input userId char[36] NOTNULL;应聘方用户id，必填
-- ##input applyGuid char[36] NOTNULL;申请guid，必填
-- ##input curUserId char[36] NOTNULL;登录用户id(也是供方用户id)，必填

set @chatfriendguid=uuid()
;
set @oldchatfriendguid=ifnull((select t1.guid from coz_chat_friend t1 where t1.demand_user_id = '{userId}' and t1.supply_user_id = '{curUserId}' limit 1),'1')
;
update coz_chat_friend_apply
set status=1
,update_time=now()
,react_time=now()
where guid='{applyGuid}'
;
insert into coz_chat_msg(guid,friend_guid,from_user_id,to_user_id,content,type,read_flag,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,case when(@oldchatfriendguid='1') then @chatfriendguid else @oldchatfriendguid end as friend_guid
,case when(cat_tree_code='demand') then target_user_id else user_id end as supply_user_id
,case when(cat_tree_code='demand') then user_id else target_user_id end as supply_user_id
,concat('与[',t.category_name,']的供方成为好友') as content
,0
,0
,0
,'-1'
,now()
,'-1'
,now()
from
coz_chat_friend_apply t
where 
t.guid='{applyGuid}'
;
insert into coz_chat_msg(guid,friend_guid,from_user_id,to_user_id,content,type,read_flag,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,case when(@oldchatfriendguid='1') then @chatfriendguid else @oldchatfriendguid end as friend_guid
,case when(cat_tree_code='demand') then user_id else target_user_id end as supply_user_id
,case when(cat_tree_code='demand') then target_user_id else user_id end as supply_user_id
,concat('与[',t.category_name,']的需方成为好友') as content
,0
,0
,0
,'-1'
,now()
,'-1'
,now()
from
coz_chat_friend_apply t
where 
t.guid='{applyGuid}'
;
insert into coz_chat_friend (guid,friend_apply_guid,demand_user_id,supply_user_id,demand_friend_remark,supply_friend_remark,del_flag,create_by,create_time,update_by,update_time)
select
*
from
(
select
@chatfriendguid as guid
,t.guid as friend_apply_guid
,case when(cat_tree_code='demand') then user_id else target_user_id end as demand_user_id
,case when(cat_tree_code='demand') then target_user_id else user_id end as supply_user_id
,case when(cat_tree_code='demand') then t2.user_name else t1.user_name end as demand_friend_remark
,case when(cat_tree_code='demand') then t1.user_name else t2.user_name end as supply_friend_remark
,'0' as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now() as update_time
from
coz_chat_friend_apply t
left join
sys_app_user t1
on t.user_id=t1.guid
left join
sys_app_user t2
on t.target_user_id=t2.guid
where 
t.guid='{applyGuid}'
)t
where
@oldchatfriendguid='1'
;
select case when(@oldchatfriendguid='1') then @chatfriendguid else @oldchatfriendguid end as friendGuid
;