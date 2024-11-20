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
    display as `key`
  , t.*
from
    (
        select
            ifnull(ifnull(t1.value, (
                                        select name
                                        from coz_model_fixed_data
                                        where guid = t3.content
                                    )),
                   t3.content)         as display
          , t3.plate_field_formal_guid as fieldGuid
          , t.name                     as fieldname
          , t3.category_guid
          , (
                select code
                from coz_model_fixed_data
                where guid = t3.content
            )                          as contentFDCode
          , t3.id
          , t.content_source
          , t3.cat_tree_code
          , t3.norder
          , t3.guid                    as valueGuid
        from
            coz_model_chat_plate_field_content_formal t3
            left join
                coz_model_chat_plate_field_formal     t
                    on t3.plate_field_formal_guid = t.guid
            left join
                coz_model_fixed_data_value            t1
                    on t3.content = t1.fixed_data_guid
        where
              t3.del_flag = '0'
          and t3.cat_tree_code = 'supply'
          and t3.category_guid = '{categoryGuid}'
          and t.content_source <> 3
    ) t
union all
select
    t1.display as `key`
  , t1.*
from
    (
        select
            ifnull(ifnull(t1.value, (
                                        select name
                                        from coz_model_fixed_data
                                        where guid = t3.content
                                    )),
                   t3.content)         as display
          , t3.plate_field_formal_guid as fieldGuid
          , t.name                     as fieldname
          , t3.category_guid
          , 2                          as biz_type
          , (
                select code
                from coz_model_fixed_data
                where guid = t3.content
            )                          as contentFDCode
          , t3.id
          , 3                          as content_source
          , 'supply'                   as cat_tree_code
          , t3.norder
          , t3.guid                    as valueGuid
        from
            coz_model_chat_plate_field_content_formal t3
            left join
                coz_model_chat_plate_field_formal     t
                    on t3.plate_field_formal_guid = t.guid
            left join
                coz_model_fixed_data_value            t1
                    on t3.content = t1.fixed_data_guid
        where
              t3.del_flag = '0'
          and t3.cat_tree_code = 'demand'
          and t3.category_guid = '{categoryGuid}'
    ) t1
order by norder, id

