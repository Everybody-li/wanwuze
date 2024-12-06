-- ##Title app-沟通模式-需方(应聘方)-查看人才信息入库-字段信息
-- ##Author lith
-- ##CreateTime 2024-11-23
-- ##Describe
-- ##CallType[QueryData]

select
    t.plate_field_formal_guid as fieldGuid
  , t.plate_field_content_gc  as `key`
  , t.plate_field_content_gc  as display
from
    coz_chat_demand_resume_plate                 t
    inner join coz_model_chat_plate_field_formal t1 on t.plate_field_formal_guid = t1.guid
where
      t.demand_resume_guid = '{demandResumeGuid}'
  and t.del_flag = '0'