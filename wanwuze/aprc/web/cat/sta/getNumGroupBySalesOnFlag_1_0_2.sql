-- ##Title web-交易条件管理-查询交易品类发布信息上下架数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易条件管理-查询交易品类发布信息上下架数量
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input cattypeGuid string[36] NOTNULL;品类类型guid，必填
-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid，必填


-- ##output salesOnNum int[>=0] NOTNULL;已上架数量
-- ##output salesOffNum int[>=0] NOTNULL;未上架数量

select (t.totalNum - t.salesOnNum) as salesOffNum, t.salesOnNum
from
    (
        select
            (
                select count(distinct t5.id) as catNum
                from
                    (
                        select cattype_guid, supply_path_guid, guid
                        from
                            coz_cattype_sd_path
                        where guid = '{sdPathGuid}' and del_flag = '0'
                    )           t1
                    left join (
                                  select guid, all_path_name from coz_cattype_supply_path where del_flag = '0'
                              ) t2 on t1.supply_path_guid = t2.guid
                    left join (
                                  select sd_path_guid, guid from coz_category_scene_tree where del_flag = '0'
                              ) t3 on t3.sd_path_guid = t1.guid
                    left join (
                                  select category_guid, scene_tree_guid
                                  from
                                      coz_category_supplydemand
                              ) t4 on t4.scene_tree_guid = t3.guid
                    left join (
                                  select guid, id
                                  from
                                      coz_category_info
                                  where del_flag = '0'
                              ) t5 on t5.guid = t4.category_guid

            ) as totalNum
          , (
                select count(distinct t5.id) as catNum
                from
                    (
                        select cattype_guid, supply_path_guid, guid
                        from
                            coz_cattype_sd_path
                        where guid = '{sdPathGuid}' and del_flag = '0'
                    )           t1
                    left join (
                                  select guid, all_path_name from coz_cattype_supply_path where del_flag = '0'
                              ) t2 on t1.supply_path_guid = t2.guid
                    left join (
                                  select sd_path_guid, guid from coz_category_scene_tree where del_flag = '0'
                              ) t3 on t3.sd_path_guid = t1.guid
                    left join (
                                  select category_guid, scene_tree_guid
                                  from
                                      coz_category_supplydemand
                              ) t4 on t4.scene_tree_guid = t3.guid
                    left join (
                                  select guid, id
                                  from
                                      coz_category_info
                                  where del_flag = '0'
                              ) t5 on t5.guid = t4.category_guid
                        and (exists(select 1
                                    from
                                        coz_category_deal_rule_log
                                    where
                                            id = (
                                                     select max(id) as id
                                                     from
                                                         coz_category_deal_rule_log
                                                     where category_guid = t5.guid
                                                 )
                                      and   serve_fee_flag = 1
                                      and   exists(select 1 from coz_category_service_fee_log where category_guid = t5.guid))
                            or exists(select 1
                                      from
                                          coz_category_deal_rule_log
                                      where
                                              id = (
                                                       select max(id) as id
                                                       from
                                                           coz_category_deal_rule_log
                                                       where category_guid = t5.guid
                                                   )
                                        and   serve_fee_flag = 0))
                        and exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getModeTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log where category_guid = t5.guid)
                        and exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getSPriceTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log where category_guid = t5.guid)
                        and exists(select 1 from coz_category_deal_deadline_log where category_guid = t5.guid)
            ) as salesOnNum
    ) t
