-- ##Title web-交易条件管理-查询交易品类发布信息上下架数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易条件管理-查询交易品类发布信息上下架数量
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input cattypeGuid string[36] NOTNULL;品类类型guid，必填
-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid，必填

select
sum(salesOnNum) as salesOnNum
,sum(salesOffNum) as salesOffNum
from
(
select
count(1) as salesOnNum
,0 as salesOffNum
from
(
select
*
from
(
select
t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
,t1.id
,case when (exists(select 1 from coz_category_deal_rule_log where category_guid=t1.guid and del_flag='0' and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as dealRulePF
,case when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getModeTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log where category_guid=t1.guid and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as dealModePF
,case when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getSPriceTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log where category_guid=t1.guid and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as dealPricePF
 , case
            when (exists(select 1
            from (select max(id), category_guid, serve_fee_flag
            from coz_category_deal_rule_log
            where t1.guid = category_guid
                and t1.del_flag = '0'
                and t1.cattype_guid = '{cattypeGuid}'
            group by category_guid) drlog
                left join coz_category_service_fee_log sflog
                on drlog.category_guid = sflog.category_guid
            where (drlog.serve_fee_flag = 1 and sflog.guid is not null)
                or drlog.serve_fee_flag = 0
                )) then '是'
            else '否' end as serviceFeePF
,case when (exists(select 1 from coz_category_deal_deadline_log a left join coz_category_deal_deadline b on a.deadline_guid=b.guid where b.category_guid=t1.guid and a.del_flag='0' and b.del_flag='0' and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as deadlinePF
from
coz_category_info t1
inner join
coz_category_supplydemand t2
on t1.guid=t2.category_guid
inner join
coz_category_scene_tree t3
on t2.scene_tree_guid=t3.guid
where
(t1.name like'%{categoryName}%' or '{categoryName}'='') and t1.del_flag='0' and t3.sd_path_guid='{sdPathGuid}'
)t1
where dealRulePF='是' and dealModePF='是' and dealPricePF='是' and serviceFeePF='是' and deadlinePF='是'
group by categoryGuid,dealRulePF,dealModePF,dealPricePF,serviceFeePF,deadlinePF
)t
union all
select
0 as salesOnNum
,count(1) as salesOffNum
from
(
select
*
from
(
select
t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
,t1.id
,case when (exists(select 1 from coz_category_deal_rule_log where category_guid=t1.guid and del_flag='0' and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as dealRulePF
,case when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getModeTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log where category_guid=t1.guid and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as dealModePF
,case when (exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\Model\getSPriceTableNamePrefixByCattype_1_0_1&cattypeGuid={cattypeGuid}&DBC=w_a]/url}_log where category_guid=t1.guid and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as dealPricePF
, case
            when (exists(select 1
            from (select max(id), category_guid, serve_fee_flag
            from coz_category_deal_rule_log
            where t1.guid = category_guid
                and t1.del_flag = '0'
                and t1.cattype_guid = '{cattypeGuid}'
            group by category_guid) drlog
                left join coz_category_service_fee_log sflog
                on drlog.category_guid = sflog.category_guid
            where (drlog.serve_fee_flag = 1 and sflog.guid is not null)
                or drlog.serve_fee_flag = 0
                )) then '是'
            else '否' end as serviceFeePF
,case when (exists(select 1 from coz_category_deal_deadline_log a left join coz_category_deal_deadline b on a.deadline_guid=b.guid where b.category_guid=t1.guid and a.del_flag='0' and b.del_flag='0' and t1.cattype_guid='{cattypeGuid}')) then '是' else '否' end as deadlinePF
from
coz_category_info t1
inner join
coz_category_supplydemand t2
on t1.guid=t2.category_guid
inner join
coz_category_scene_tree t3
on t2.scene_tree_guid=t3.guid
where
(t1.name like'%{categoryName}%' or '{categoryName}'='') and t1.del_flag='0' and t3.sd_path_guid='{sdPathGuid}'
)t1
where dealRulePF='否' or dealModePF='否' or dealPricePF='否' or serviceFeePF='否' or deadlinePF='否'
group by categoryGuid,dealRulePF,dealModePF,dealPricePF,serviceFeePF,deadlinePF
)t
)t
