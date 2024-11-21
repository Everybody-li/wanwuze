-- ##Title app-沟通模式-需方(应聘方)-受邀记录管理-查询已处理记录列表
-- ##Author lith
-- ##CreateTime 2024-11-19
-- ##Describe
-- ##CallType[QueryData]


-- ##input page int[>0] NOTNULL;第几页
-- ##input size int[>0] NOTNULL;每页数量
-- ##input curUserId string[36] NOTNULL;登录用户id字段

-- ##output invitelogGuid char[36] ;邀请记录guid
-- ##output supplyResumeGuid char[36] ;供方人才查找guid
-- ##output userId char[36] ;供方用户id
-- ##output userName string[20] ;供方用户姓名
-- ##output userImg string[1024] ;供方简历图片,多个用逗号分割
-- ##output inviteTime char[19] ;邀请时间
-- ##output inviteStatus enum[0,1] ;邀请状态:1-同意加好友,2-拒绝加好友


select
    t1.guid  as invitelogGuid
  , t1.supply_user_id  as userId
  , t3.user_name            as userName
  , t1.supply_user_img as userImg
  , t2.create_time     as inviteTime
  , t2.`status`        as inviteStatus
from
    coz_chat_supply_resume_invitelog t1
    left join
        coz_chat_friend_apply        t2 on t1.guid = t2.recruit_guid
    left join
        sys_app_user                 t3 on t1.supply_user_id = t3.guid
where t1.demand_user_id = '{curUserId}' and t2.status in ('1','2')
    Limit {compute:[({page}-1)*{size}]/compute},{size};