-- ##Title app-沟通模式-需方(应聘方)-个人信息入库-删除
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe <p style="color:red">如果需方未录入个人信息,则删除按钮置灰不可点击 </p>
-- ##CallType[ExSql]

-- ##input demandResumeGuid char[36] NOTNULL;需方个人信息入库guid
-- ##input curUserId string[36] NOTNULL;登录用户id字段


update
    coz_chat_demand_resume
set
    del_flag  = '2'
  , update_time = now()
where guid = '{demandResumeGuid}'
;