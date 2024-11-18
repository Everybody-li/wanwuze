-- ##Title app-沟通模式-需方(应聘方)-个人信息入库-版本是否失效
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe <p style="color:red">型号专员有发布新版本,且新版本影响到当前用户的个人信息入库内容,则内容失效,弹窗提示用户重新编辑 </p>
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id字段

-- ##output demandResumeGuid char[36] ;需方个人信息入库guid
-- ##output status enum[0,1] ;需方个人信息入库内容是否失效:0-失效,1-生效
-- ##output statusTime char[19] ;需方个人信息入库内容失效时间:0000-00-00 00:00:00
-- ##output msg string[100] ;失效弹窗提示语:个人信息有新版本发布，请按照最新版本编辑入库。


select
    guid        as demandResumeGuid
  , `status`    as status
  , status_time as statusTime
from
    coz_chat_demand_resume
where user_id = '{curUserId}' and del_flag = '0'
order by id desc
limit 1
;