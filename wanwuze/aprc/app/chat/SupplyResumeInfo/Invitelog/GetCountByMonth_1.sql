-- ##Title app-沟通模式-供方(招聘方)-邀约记录管理-按月统计
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe
-- ##CallType[QueryData]


-- ##input page int[>0] NOTNULL;第几页
-- ##input size int[>0] NOTNULL;每页数量
-- ##input curUserId string[36] NOTNULL;登录用户id字段

-- ##output month char[7] ;年月:0000-00
-- ##output inviteCount int[>=0] ;邀约数量


select count(1) as inviteCount,date_format(create_time,'%Y-%m') as month
from
    coz_chat_supply_resume_invitelog
where supply_user_id = '{curUserId}'
group by month
order by month desc
Limit {compute:[({page}-1)*{size}]/compute},{size}

