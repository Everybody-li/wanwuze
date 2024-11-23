-- ##Title app-沟通模式-需方(应聘方)-查看人才信息入库-板块信息
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe
-- ##CallType[QueryData]

-- ##input demandResumeGuid string[500] NOTNULL;需方入库人才信息guid
-- ##input curUserId string[36] NOTNULL;登录用户id

-- ##output status enum[0,1] ;状态:0-失效,1-生效
-- ##output norder int[>0] ;板块顺序
-- ##output alias string[20] ;板块别名
-- ##output plateGuid char[36] ;板块guid
-- ##output plateCode char[6] ;板块code


select
    t.status        as status
  , t.plate_norder       as norder
  , t.plate_formal_alias as alias
  , t.plate_formal_guid  as plateGuid
  , t.plate_code         as plateCode
  , CONCAT('{ChildRows_aprc\\app\\chat\\DemandResumeInfo\\plates\\getPlateFields_1_0_1:plateGuid=''', t.plate_formal_guid,
           '''}')        as `field`
from
    coz_chat_demand_resume_plate t
where
      t.demand_resume_guid = '{demandResumeGuid}'
  and t.del_flag = '0'
group by t.status, t.plate_norder, t.plate_formal_alias, t.plate_formal_guid