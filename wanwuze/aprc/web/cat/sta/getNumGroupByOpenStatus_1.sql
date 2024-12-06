-- ##Title web-运营经理操作系统-品类交易管理-交易信息信息管理-已上架-统计已开放和未开放数量
-- ##Author lith
-- ##CreateTime 2024-09-27
-- ##Describe
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid，必填
-- ##input cattypeGuid string[36] NOTNULL;品类类型guid，必填
-- ##input curUserId string[36] NOTNULL;用户id，必填


-- ##output catOpenStatusOnNum int[>=0] ;已开放数量
-- ##output catOpenStatusOffNum int[>=0] ;未开放数量

with t as (
                select count(distinct t5.id) as catNum,open_status as catOpenStatus
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
                                  where del_flag = '0'
                              ) t4 on t4.scene_tree_guid = t3.guid
                    left join (
                                  select guid, id,open_status
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
                group by t5.open_status
            )
select
    ifnull((
           select t.catNum
           from
               t
           where t.catOpenStatus = '1'
       ) , 0) as catOpenStatusOnNum
  ,  ifnull((
        select t.catNum
        from
            t
        where t.catOpenStatus = '0'
    ) , 0) as catOpenStatusOffNum;


