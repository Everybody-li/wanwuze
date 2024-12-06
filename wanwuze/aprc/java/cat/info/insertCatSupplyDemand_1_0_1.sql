-- ##Title 新增已存在的品类名称与场景的关联关系(批量调用)
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增已存在的品类名称与场景的关联关系(批量调用)
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input remark string[200] NOTNULL;备注，必填


INSERT INTO
    coz_category_supplydemand
    ( guid, category_guid, scene_tree_guid, remark, del_flag, create_by, create_time, update_by, update_time )
select
    uuid()           as guid
  , '{categoryGuid}' as categoryGuid
  , '{secenGuid}'    as scene_tree_guid
  , '{remark}'       as remark
  , '0'              as del_flag
  , '-1'             as create_by
  , now()            as create_time
  , '-1'             as update_by
  , now()            as update_time
where
    not exists(select 1
               from coz_category_supplydemand
               where scene_tree_guid = '{secenGuid}' and category_guid = '{categoryGuid}' and del_flag = '0')
