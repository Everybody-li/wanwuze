-- ##Title app-供应-根据末级场景查询品类列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-根据末级场景查询品类列表_1_0_1
-- ##CallType[QueryData]

-- ##input secenGuid string[36] NOTNULL;末级场景guid，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input treeName1 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName2 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName3 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName4 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName5 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName6 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName7 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName8 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName9 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input treeName10 string[50] NULL;品类字节内容，必填(treeName1，treeName2，treeName3````````treeName10至少传一个)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


set @col = concat(CAST('{treeName1}' AS char CHARACTER SET utf8),
                  CAST('{treeName2}' AS char CHARACTER SET utf8),
                  CAST('{treeName3}' AS char CHARACTER SET utf8),
                  CAST('{treeName4}' AS char CHARACTER SET utf8),
                  CAST('{treeName5}' AS char CHARACTER SET utf8),
                  CAST('{treeName6}' AS char CHARACTER SET utf8),
                  CAST('{treeName7}' AS char CHARACTER SET utf8),
                  CAST('{treeName8}' AS char CHARACTER SET utf8),
                  CAST('{treeName9}' AS char CHARACTER SET utf8),
                  CAST('{treeName10}' AS char CHARACTER SET utf8),
                  CAST('%' AS char CHARACTER SET utf8));

select
    categoryGuid
  , categoryName
  , alias
  , img
  , categoryMode
  , buttonStatus
  , buttonStatusName
  , sdFlag
  , priceMode
from
    (
        select *
             , if(catAddedFlag = 0, btn_name_1, btn_name_4) as buttonStatusName
             , if(catAddedFlag = 0, '1', '4')               as buttonStatus
             , 1                                            as idx
        from
            (
                select
                    t.guid   as categoryGuid
                  , t.name   as categoryName
                  , t.alias
                  , t.img
                  , t.mode   as categoryMode
                  , (
                        select price_mode
                        from
                            coz_category_deal_rule_log
                        where category_guid = t.guid and del_flag = '0'
                        order by id desc
                        limit 1
                    )        as priceMode
                  , 'demand' as sdFlag
                  , t5.btn_name_1
                  , t5.btn_name_4
                  , if(exists(select 1
                              from
                                  coz_category_supplier cas
                              where cas.category_guid = t.guid and user_id = '{curUserId}' and cas.del_flag = '0'),
                       1, 0) as catAddedFlag
                  , t.id
                from
                    coz_category_info             t
                    left join
                        coz_category_supplydemand t1
                            on t1.category_guid = t.guid
                    left join
                        coz_category_scene_tree   t2
                            on t1.scene_tree_guid = t2.guid
                    left join
                        coz_cattype_sd_path       t3
                            on t2.sd_path_guid = t3.guid
                    left join
                        coz_cattype_demand_path   t4
                            on t3.demand_path_guid = t4.guid
                    left join
                        coz_cattype_supply_path   t5
                            on t3.supply_path_guid = t5.guid
                where
                      t1.scene_tree_guid = '{secenGuid}'
                  and t.del_flag = '0'
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t3.del_flag = '0'
                  and t4.del_flag = '0'
                  and t5.del_flag = '0'
                  and (t.name like @col or @col = '%')
            ) t
    ) t
order by t.idx, t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};


