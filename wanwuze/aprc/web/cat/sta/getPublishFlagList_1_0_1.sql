-- ##Title web-查询交易信息跟踪管理列表交易类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询交易信息跟踪管理列表交易类
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t.guid as categoryGuid
,t.name as categoryName
,t.cattype_name as cattypeName
,case when (exists(select 1 from coz_category_deal_rule_log where category_guid=t.guid and del_flag=''0'')) then ''是'' else ''否'' end as dealRulePF
,case when (exists(select 1 from coz_category_deal_mode_log where category_guid=t.guid and del_flag=''0'')) then ''是'' else ''否'' end as dealModePF
,case when (exists(select 1 from coz_category_supply_price_log where category_guid=t.guid and del_flag=''0'')) then ''是'' else ''否'' end as dealPricePF
,case when (exists(select 1 from coz_category_service_fee_log where category_guid=t.guid and del_flag=''0'')) then ''是'' else ''否'' end as serviceFeePF
,case when (exists(select 1 from coz_category_deal_deadline_log a left join coz_category_deal_deadline b on a.deadline_guid=b.guid where b.category_guid=t.guid and a.del_flag=''0'' and b.del_flag=''0'')) then ''是'' else ''否'' end as deadlinePF
from
coz_category_info t
where 
(t.name like''%{categoryName}%'' or ''{categoryName}''='''') and t.mode=2 and t.del_flag=''0''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
