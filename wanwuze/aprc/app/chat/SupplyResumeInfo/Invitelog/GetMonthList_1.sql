-- ##Title app-沟通模式-供方(招聘方)-邀约记录管理-查询每月详情列表
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe
-- ##CallType[QueryData]

-- ##input month char[7] NOTNULL;品类路径guid
-- ##input page int[>0] NOTNULL;第几页
-- ##input size int[>0] NOTNULL;每页数量
-- ##input curUserId string[36] NOTNULL;登录用户id字段

-- ##output demandResumeGuid char[36] ;需方个人信息入库guid
-- ##output userId char[36] ;需方用户id
-- ##output userName string[20] ;需方用户姓名
-- ##output userImg string[42] ;需方简历图片
-- ##output inviteTime char[19] ;邀请时间:0000-00-00 00:00:00


select date_format(t1.create_time, '%Y-%m') as month
     , t1.demand_user_id userId
     , t2.user_name userName
     , t1.demand_user_img userImg
     , t1.create_time inviteTime
from
    coz_chat_supply_resume_invitelog t1
    inner join sys_app_user          t2 on t1.demand_user_id = t2.guid
where
    supply_user_id = '{curUserId}'and t2.del_flag = '0'
order by t1.id
desc
    Limit {compute:[({page}-1)*{size}]/compute},{size}

