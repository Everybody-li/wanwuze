-- ##Title web-添加板块
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-添加板块
-- ##CallType[ExSql]

-- ##input catTreeCode string[50] NOTNULL;供需/采购类型（demand：采购，supply：供应）
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid
-- ##input fixedDataCode string[50] NOTNULL;固化库板块名称code
-- ##input fixedDataName string[50] NOTNULL;固化库板块名称
-- ##input bizType enum[1,2,3,4] NOTNULL;业务类型：1-供需需求信息配置，2-供应报价信息配置，3-简历需求信息配置，4-采购资质信息配置
-- ##input curUserId string[36] NOTNULL;登录用户id



update coz_category_deal_mode
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where '{bizType}' = 1 and category_guid = '{categoryGuid}' and publish_flag= '2';

update coz_category_supply_price
set
    publish_flag='0'
  , update_by='{curUserId}'
  , update_time=now()
  , publish_time= null
where '{bizType}' = 2  and category_guid = '{categoryGuid}' and publish_flag= '2';


insert into
    coz_model_plate
    ( guid, cattype_guid, cat_tree_code, category_guid, biz_type, fixed_data_code, alias, norder, publish_flag, del_flag
    , create_by, create_time, update_by, update_time )
select *
from
    (
        select
            UUID()            as guid
          , cattype_guid      as cattype_guid
          , '{catTreeCode}'   as cat_tree_code
          , '{categoryGuid}'  as category_guid
          , '{bizType}'       as biz_type
          , '{fixedDataCode}' as fixedDataCode
          , (
                select name from coz_model_fixed_data where code = '{fixedDataCode}' and del_flag = '0'
            )                 as alias
          , ifnull((
                       select (max(norder) + 1)
                       from
                           coz_model_plate
                       where
                             cat_tree_code = '{catTreeCode}'
                         and del_flag = '0'
                         and category_guid = '{categoryGuid}'
                         and biz_type = '{bizType}'
                   ), 1)      as norder
          , '0'               as publish_flag
          , '0'               as del_flag
          , '-1'              as ascreate_by
          , now()             as create_time
          , '-1'              as update_by
          , now()             as update_time
        from
            coz_category_info
        where
              not exists(select 1
                         from
                             coz_model_plate
                         where
                               cat_tree_code = '{catTreeCode}'
                           and category_guid = '{categoryGuid}'
                           and biz_type = '{bizType}'
                           and fixed_data_code = '{fixedDataCode}'
                           and del_flag = '0')
          and guid = '{categoryGuid}'
        union all
        select
            UUID()            as guid
          , guid              as cattype_guid
          , '{catTreeCode}'   as cat_tree_code
          , '{categoryGuid}'  as category_guid
          , '{bizType}'       as biz_type
          , '{fixedDataCode}' as fixedDataCode
          , (
                select name from coz_model_fixed_data where code = '{fixedDataCode}' and del_flag = '0'
            )                 as alias
          , ifnull((
                       select (max(norder) + 1)
                       from
                           coz_model_plate
                       where
                             cat_tree_code = '{catTreeCode}'
                         and del_flag = '0'
                         and category_guid = '{categoryGuid}'
                         and biz_type = '{bizType}'
                   ), 1)      as norder
          , '0'               as publish_flag
          , '0'               as del_flag
          , '-1'              as ascreate_by
          , now()             as create_time
          , '-1'              as update_by
          , now()             as update_time
        from
            coz_cattype_fixed_data
        where
              not exists(select 1
                         from
                             coz_model_plate
                         where
                               cat_tree_code = '{catTreeCode}'
                           and category_guid = '{categoryGuid}'
                           and biz_type = '{bizType}'
                           and fixed_data_code = '{fixedDataCode}'
                           and del_flag = '0')
          and guid = '{categoryGuid}'
    ) t
;
