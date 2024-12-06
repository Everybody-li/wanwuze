-- ##Title app-沟通模式-供方(招聘方)-入库人才查找-邀约面试
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe
-- ##CallType[ExSql]

-- ##input supplyResumeGuid char[36] NOTNULL;供方入库人才查找条件guid字段
-- ##input demandResumeGuid char[36] NOTNULL;需方个人信息入库guid
-- ##input userId char[36] NOTNULL;需方用户id
-- ##input userImg string[50] NOTNULL;需方用户简历图片,例如:7f07756f-e437-4eea-818a-275a26b32079.png
-- ##input curUserId string[36] NOTNULL;登录用户id字段

set @repeatFlag = 0;
select count(1) into @repeatFlag
               from
                   coz_chat_supply_resume_invitelog
               where
                     supply_resume_guid = 'cdd2c9f4-a3d8-43b5-b9f7-e1ab1fd28a9f'
                 and demand_resume_guid = '935d4f47-f36a-11ec-bace-0242ac120003';

set @invitelogGuid = uuid();
set @sdPathGuid = '';
select sd_path_guid into @sdPathGuid from coz_chat_supply_resume where guid = '{supplyResumeGuid}' and del_flag = '0';

insert into
    coz_chat_supply_resume_invitelog( guid, supply_resume_guid, supply_user_id, supply_user_img
                                    , demand_resume_guid, demand_user_id, demand_user_img
                                    , create_by, create_time )
select
    @invitelogGuid       as guid
  , '{supplyResumeGuid}' as supply_resume_guid
  , '{curUserId}'        as supply_user_id
  , (
           select
            group_concat(img separator ',')
        from
            coz_user_biz_img  t1
        inner join coz_cattype_sd_path t2 on t1.supply_path_guid= t2.supply_path_guid
        where user_id = '{curUserId}' and t2.guid = @sdPathGuid and t1.del_flag = '0' and t2.del_flag = '0'
    )                    as supply_user_img
  , '{demandResumeGuid}' as demand_resume_guid
  , '{userId}'           as demand_user_id
  , '{userImg}'          as demand_user_img
  , '{curUserId}'        as create_by
  , now()                as create_time
where
    @repeatFlag = 0
;

insert into
    coz_chat_friend_apply
    ( guid, cat_tree_code, user_id, target_user_id, recruit_guid, category_guid, category_name
    , create_by, create_time, update_by, update_time )
select
    uuid()
  , 'supply'
  , '{curUserId}'
  , '{userId}'
  , @invitelogGuid
  , category_guid
  , category_name
  , '{curUserId}'
  , now()
  , '{curUserId}'
  , now()
from
    coz_chat_demand_resume
where
     @repeatFlag = 0 and guid = '{demandResumeGuid}'
;