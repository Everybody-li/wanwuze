-- ##Title app-沟通模式-需方(应聘方)-受邀记录管理-删除受邀记录
-- ##Author lith
-- ##CreateTime 2024-11-20
-- ##Describe
-- ##CallType[ExSql]


-- ##input invitelogGuid char[36] NOTNULL;邀请记录guid



delete
from
    coz_chat_supply_resume_invitelog t1
where t1.guid = '{invitelogGuid}'

