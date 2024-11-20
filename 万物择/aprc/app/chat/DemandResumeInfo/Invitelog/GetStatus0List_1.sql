-- ##Title app-沟通模式-需方(应聘方)-受邀记录管理-查询未处理记录列表
-- ##Author lith
-- ##CreateTime 2024-11-19
-- ##Describe
-- ##CallType[QueryData]


-- ##input page int[>0] NOTNULL;第几页
-- ##input size int[>0] NOTNULL;每页数量
-- ##input curUserId string[36] NOTNULL;登录用户id字段

-- ##output supplyResumeGuid char[36] ;供方人才查找guid
-- ##output userId char[36] ;供方用户id
-- ##output userName string[20] ;供方用户姓名
-- ##output userImg string[42] ;供方简历图片


select t1.supply_user_id
from
    coz_chat_supply_resume_invitelog t1
    left join
        coz_chat_friend_apply        t2 on t1.guid = t2.recruit_guid
where t1.demand_user_id = '{curUserId}' and t2.status = '0'

