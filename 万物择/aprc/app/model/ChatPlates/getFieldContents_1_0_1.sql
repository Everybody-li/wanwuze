-- ##Title app-沟通模式-查询字段内容配置列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe
-- ##CallType[QueryData]

-- ##output key String[20] 板块字段内容候选项或文件模板key;板块字段内容候选项或文件模板key，（当板块字段内容来源=1，是固化的时候，key存的是fixedDataGuid，其他时候存具体值）
-- ##output display String[20] 板块字段内容候选项或文件模板展示值;板块字段内容候选项或文件模板展示值
-- ##output contentFDCode string[50] 板块字段内容code;板块字段内容code(非固化的值为空)
-- ##output valueGuid char[36] 板块字段内容候选项guid;板块字段内容候选项guid

select
    t1.guid                     as fieldGuid
  , ifnull(t3.code, t2.content) as `key`
  , ifnull(t4.`value`, t3.name) as display
  , t3.code                     as contentFDCode
  , ifnull(t4.guid, t3.guid)    as valueGuid
from
    coz_model_chat_plate_field_formal                    t1
    inner join coz_model_chat_plate_field_content_formal t2 on t1.guid = t2.plate_field_formal_guid
    inner join coz_model_fixed_data                      t3 on t2.content = t3.guid
    left join  coz_model_fixed_data_value                t4 on t3.guid = t4.fixed_data_guid
where
      t1.category_guid = '{categoryGuid}'
  and t1.cat_tree_code = '{catTreeCode}'
  and t1.content_source = '1' --  查固化库
union all
select
    t1.guid    as fieldGuid
  , t2.content as `key`
  , t2.content as display
  , ''         as contentFDCode
  , ''         as valueGuid
from
    coz_model_chat_plate_field_formal                    t1
    inner join coz_model_chat_plate_field_content_formal t2 on t1.guid = t2.plate_field_formal_guid
where
      t1.category_guid = '{categoryGuid}'
  and t1.cat_tree_code = '{catTreeCode}'
  and t1.content_source = '2' --  查自建库
union all
select
    t5_su.guid                  as fieldGuid
  , ifnull(t3.code, t2.content) as `key`
  , ifnull(t4.`value`, t3.name) as display
  , t3.code                     as contentFDCode
  , ifnull(t4.guid, t3.guid)    as valueGuid
from
    coz_model_chat_plate_field_formal                    t1
    inner join coz_model_chat_plate_field_content_formal t2 on t1.guid = t2.plate_field_formal_guid
    inner join coz_model_fixed_data                      t3 on t2.content = t3.guid
    left join  coz_model_fixed_data_value                t4 on t3.guid = t4.fixed_data_guid
    inner join coz_model_chat_plate_field_formal         t5_su on t1.guid = t5_su.demand_pf_formal_guid
where
      '{catTreeCode}' = 'supply'
  and t1.category_guid = '{categoryGuid}'
  and t1.cat_tree_code = 'demand'
  and t1.content_source = '1' --  查同需方固化库
union all
select
    t5_su.guid as fieldGuid
  , t2.content as `key`
  , t2.content as display
  , ''         as contentFDCode
  , ''         as valueGuid
from
    coz_model_chat_plate_field_formal                    t1
    inner join coz_model_chat_plate_field_content_formal t2 on t1.guid = t2.plate_field_formal_guid
    inner join coz_model_chat_plate_field_formal         t5_su on t1.guid = t5_su.demand_pf_formal_guid
where
      '{catTreeCode}' = 'supply'
  and t1.category_guid = '{categoryGuid}'
  and t1.cat_tree_code = 'demand'
  and t1.content_source = '2' --  查同需方的自建库