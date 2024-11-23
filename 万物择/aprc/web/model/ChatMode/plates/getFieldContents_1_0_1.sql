-- ##Title web-查询已添加的字段内容管理数据列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-查询已添加的字段内容管理数据列表
-- ##CallType[QueryData]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

select
    t.plate_field_guid     as plateFieldGuid
  , t.guid                 as fieldContentGuid
  , case
        when (t1.content_source = '1') then (
                                                select name
                                                from coz_model_fixed_data
                                                where guid = t.content and del_flag = '0'
        )
        else t.content end as content
from
    coz_model_chat_plate_field_content t
    left join
        coz_model_chat_plate_field     t1
            on t.plate_field_guid = t1.guid
where
      t.plate_field_guid = '{plateFieldGuid}'
  and t.del_flag = '0'
order by t.id
Limit {compute:[({page}-1)*{size}]/compute},{size}
