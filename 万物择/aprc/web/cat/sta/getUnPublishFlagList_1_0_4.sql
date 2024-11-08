-- ##Title web-查询交易信息跟踪管理列表交易类-未上架_1_0_4
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易信息跟踪管理列表交易类-未上架_1_0_4
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input cattypeGuid string[36] NOTNULL;品类类型guid，必填
-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
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
            where category_guid = t1.guid and del_flag = ''0'' and t1.cattype_guid = ''{cattypeGuid}'')) then ''是'' else ''否'' end as dealRulePF
            ,case
            when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getModeTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log
            where category_guid = t1.guid and del_flag = ''0'' and t1.cattype_guid = ''{cattypeGuid}'')) then ''是'' else ''否'' end as dealModePF
            ,case
            when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getSPriceTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log
            where category_guid = t1.guid and del_flag = ''0'' and t1.cattype_guid = ''{cattypeGuid}'')) then ''是'' else ''否'' end as dealPricePF
            , case
            when (exists(select 1
            from (select max(id), category_guid, serve_fee_flag
            from coz_category_deal_rule_log
            where t1.guid = category_guid
                and t1.del_flag = ''0''
                and t1.cattype_guid = ''{cattypeGuid}''
            group by category_guid) drlog
                left join coz_category_service_fee_log sflog
                on drlog.category_guid = sflog.category_guid
            where (drlog.serve_fee_flag = 1 and sflog.guid is not null)
                or drlog.serve_fee_flag = 0
                )) then ''是''
            else ''否'' end as serviceFeePF
            ,case
            when (exists(select 1 from coz_category_deal_deadline_log a left join coz_category_deal_deadline b on a.deadline_guid = b.guid
            where b.category_guid = t1.guid and a.del_flag = ''0'' and b.del_flag = ''0'' and t1.cattype_guid = ''{cattypeGuid}'')) then ''是'' else ''否'' end as deadlinePF
            ,(select count(1) from coz_category_status_feedback
        where category_guid = t1.guid and del_flag = ''0'') as catStaFeedbackCount
        from
            coz_category_info t1
        where
            (t1.name like ''%{categoryName}%'' or ''{categoryName}'' = '''') and t1.del_flag = ''0'' and t1.cattype_guid = ''{cattypeGuid}''
        ) t1
where dealRulePF = ''否'' or dealModePF = ''否'' or dealPricePF = ''否'' or serviceFeePF = ''否'' or deadlinePF = ''否''
order by t1.id desc
limit ?,?;
';
SET @start = (({page} - 1) * {size});
SET @end = ({size});
EXECUTE q1 USING @start,@end;
