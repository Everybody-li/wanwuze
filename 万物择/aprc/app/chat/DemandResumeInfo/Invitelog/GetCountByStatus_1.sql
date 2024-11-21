-- ##Title app-沟通模式-需方(应聘方)-受邀记录管理-按处理状态统计
-- ##Author lith
-- ##CreateTime 2024-11-19
-- ##Describe
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id

-- ##output processStatus enum[0,1] ;处理状态:0-未处理,1-已处理
-- ##output processStatusStr enum[未处理,已处理] ;处理状态说明:未处理,已处理
-- ##output inviteCount int[>=0] ;招聘者数量
-- ##output showRedPoint enum[0,1] ;是否展示红点:0-否,1-是


select *, if(tt.processStatus = 0 and inviteCount = 0, 1, 0) as showRedPoint
from
    (
        select
            count(t.recruit_guid)                        as inviteCount
          , ps.processStatus
          , if(ps.processStatus = 0, '未处理', '已处理') as processStatusStr
        from
            (
                select 0 as processStatus
                union all
                select 1 as processStatus
            )     ps
            left join
                (
                    select if(t2.status = '0', 0, 1) as processStatus, t2.recruit_guid
                    from
                        coz_chat_supply_resume_invitelog t1
                        left join
                            coz_chat_friend_apply        t2 on t1.guid = t2.recruit_guid
                    where t1.demand_user_id = 'fd99005c-2fd0-4a17-811e-1e2e2e2b98e5'
#                     where t1.demand_user_id = '{curUserId}'
                ) t on ps.processStatus = t.processStatus
        group by processStatus
    ) tt
order by processStatus

