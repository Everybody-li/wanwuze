-- ##Title web-查询字段内容详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段内容详情
-- ##CallType[QueryData]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output plateFieldGuid char[36] ;字段名称guid
-- ##output plateFieldName char[36] ;字段名称
-- ##output plateFieldSource char[36] ;字段名称

select
    t.guid           as plateFieldGuid
  , case
        when (t.source = 2) then t.name
        else (
                 select name
                 from coz_model_fixed_data
                 where code = t.name
        ) end        as plateFieldName
  , t.Source         as plateFieldSource
  , t.cat_tree_code  as catTreeCode
  , t.content_source as fieldContentSource
  , t.operation
  , t.placeholder
  , case
        when (t.content_source = '0') then '0'
        when ((t.content_source = '1' or t.content_source = '2') and not exists(select 1
                                                                                from coz_model_plate_field_content
                                                                                where plate_field_guid = t.guid and del_flag = '0'))
            then '0'
        else '1' end as contentSetFlag
from
    coz_model_plate_field t
where
      t.guid = '{plateFieldGuid}'
  and t.del_flag = '0'
order by t.id 