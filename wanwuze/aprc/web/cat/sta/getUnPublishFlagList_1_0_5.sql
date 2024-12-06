-- ##Title web-查询交易信息跟踪管理列表交易类-未上架_1_0_5
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易信息跟踪管理列表交易类-未上架_1_0_5
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input cattypeGuid string[36] NOTNULL;品类类型guid，必填
-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid，必填

-- ##output dealRulePF char[1] NOTNULL;交易规则是否发布
-- ##output dealModePF char[1] NOTNULL;供需需求信息是否发布
-- ##output dealPricePF char[1] NOTNULL;是否有供应报价信息
-- ##output serviceFeePF char[1] NOTNULL;是否有服务定价信息
-- ##output deadlinePF char[1] NOTNULL;是否已经有验收期限信息
-- ##output catStaFeedbackCount char[1] NOTNULL;采购供应路径Guid，必填

select
    *
from
        (
        select
            t1.guid as categoryGuid
            ,t1.name as categoryName
            ,t1.cattype_name as cattypeName
            ,t1.id
            ,case
            when (exists(select 1 from coz_category_deal_rule_log
            where category_guid = t1.guid )) then '是' else '否' end as dealRulePF
            ,case
            when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getModeTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log
            where category_guid = t1.guid )) then '是' else '否' end as dealModePF
            ,case
            when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getSPriceTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log
            where category_guid = t1.guid )) then '是' else '否' end as dealPricePF
            , case
            when (exists(select 1
                      from
                          coz_category_deal_rule_log
                      where
                              id = (
                                       select max(id) as id
                                       from
                                           coz_category_deal_rule_log
                                       where category_guid = t1.guid
                                   )
                        and   serve_fee_flag = 1
                        and   exists(select 1 from coz_category_service_fee_log where category_guid = t1.guid))
                or exists(select 1
                                      from
                                          coz_category_deal_rule_log
                                      where
                                              id = (
                                                       select max(id) as id
                                                       from
                                                           coz_category_deal_rule_log
                                                       where category_guid = t1.guid
                                                   )
                                        and   serve_fee_flag = 0)
                ) then '是'
            else '否' end as serviceFeePF
            ,case
            when (exists(select 1 from coz_category_deal_deadline_log a
            where a.category_guid = t1.guid and a.del_flag = '0' )) then '是' else '否' end as deadlinePF
            ,(select count(1) from coz_category_status_feedback
        where category_guid = t1.guid and del_flag = '0') as catStaFeedbackCount
        from
         (
                select
                    t1.guid
                  , t1.name
                  , t1.cattype_guid
                  , t1.cattype_name
                  , t1.open_status
                  , t1.id
                  , t3.sd_path_guid
                from
                    coz_category_info                    t1
                    inner join coz_category_supplydemand t2 on t1.guid = t2.category_guid
                    inner join coz_category_scene_tree   t3 on t2.scene_tree_guid = t3.guid
                where  t3.sd_path_guid = '{sdPathGuid}' {dynamic:categoryName[ and t1.name like '%{categoryName}%']/dynamic} and t1.del_flag = '0' and t2.del_flag = '0' and t3.del_flag = '0'
                group by t1.guid, t1.name, t1.cattype_guid, t1.cattype_name, t1.open_status, t1.id
            ) t1
        ) t1
where dealRulePF = '否' or dealModePF = '否' or dealPricePF = '否' or serviceFeePF = '否' or deadlinePF = '否'
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};

