-- ##Title app-沟通模式-需方(应聘方)-个人信息入库-个人信息
-- ##Author lith
-- ##CreateTime 2024-11-18
-- ##Describe
-- ##CallType[ExSql]

-- ##input demandResumeGuid char[36] NOTNULL;需方个人信息入库guid
-- ##input sdPathGuid char[36] NOTNULL;品类路径guid
-- ##input categoryGuid char[36] NOTNULL;品类名称guid字段
-- ##input userId char[36] NOTNULL;用户id字段
-- ##input userName string[36] NOTNULL;用户名称字段
-- ##input userPhone string[15] NOTNULL;用户手机号字段
-- ##input curUserId string[36] NOTNULL;登录用户id字段

insert into
    coz_chat_demand_resume( guid, sd_path_guid, cattype_guid, cattype_name
                          , category_guid, category_name, category_img, category_alias
                          , sales_flag, sales_time
                          , status, status_time
                          , user_id, user_name, user_phone
                          , del_flag, create_by, create_time, update_by, update_time )
select
    '{demandResumeGuid}' as guid
  , '{sdPathGuid}'       as sdPathGuid
  , guid                 as cattypeGuid
  , name                 as cattypeName
  , guid                 as categoryGuid
  , name                 as categoryName
  , t.img                as categoryImg
  , name                 as categoryAlias
  , '1'                  as sales_flag
  , now()                as sales_time
  , '1'                  as `status`
  , now()                as status_time
  , '{curUserId}'           as userId
  , '{userName}'         as userName
  , '{userPhone}'        as userPhone
  , 0                    as del_flag
  , '{curUserId}'        as create_by
  , now()                as create_time
  , '{curUserId}'        as update_by
  , now()                as update_time
from
    coz_cattype_fixed_data t
where guid = '{categoryGuid}'
;