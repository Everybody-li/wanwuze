-- ##Title app-供应-根据品类名称模糊搜索品类列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-根据品类名称模糊搜索品类列表_1_0_1
-- ##CallType[QueryData]

-- ##input sdPathGuid string[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input categoryName string[200] NULL;品类名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
categoryGuid
,categoryName
,alias
,img
,categoryMode
,buttonStatus
,buttonStatusName
,sdFlag
,priceMode
from
(
select
*
,case when (flag1=''1'' or flag2=''1'') then btn_name_2  when (flag3=''1'') then btn_name_4 when (flag4=''1'' or flag5=''1'') then btn_name_1 else btn_name_3 end as buttonStatusName
,case when (flag1=''1'' or flag2=''1'') then ''2'' when (flag3=''1'') then ''4'' when (flag4=''1'' or flag5=''1'') then ''1''  else ''3'' end as buttonStatus
,case when (flag1=''1'' or flag2=''1'') then ''2'' when (flag3=''1'') then ''3'' when (flag4=''1'' or flag5=''1'') then ''1''  else ''4'' end as idx
from
(
select
t.guid as categoryGuid
,t.name as categoryName
,t.alias
,t.img
,t.mode as categoryMode
,case when(exists(select 1 from coz_app_user_permission where user_id=''{curUserId}'' and type=3 and del_flag=''0'' and status=''1'')) then ''1'' else ''0'' end as flag1
,case when(exists(select 1 from coz_app_user_permission_detail where biz_guid=t.guid and user_id=''{curUserId}'' and type=5 and del_flag=''0'')) then ''1'' else ''0'' end as flag2
,case when(exists(select 1 from coz_category_supplier where user_id=''{curUserId}'' and category_guid=t.guid and del_flag=''0'')) then ''1'' else ''0'' end as flag3

,case when(exists(select 1 from coz_category_deal_rule_log a right join (select category_guid,max(id) as MID from coz_category_deal_rule_log group by category_guid) b on a.id=b.MID left join coz_category_deal_rule c on a.deal_rule_guid=c.guid where a.category_guid=t.guid and c.serve_fee_flag=''1'' and a.del_flag=''0'' and c.del_flag=''0'') and exists(select 1 from coz_category_deal_mode_log where category_guid=t.guid) and exists(select 1 from coz_category_supply_price_log where category_guid=t.guid) and exists(select 1 from coz_category_service_fee_log where category_guid=t.guid) and exists(select 1 from coz_category_deal_deadline_log where category_guid=t.guid))  then ''1'' else ''0'' end as flag4

,case when(exists(select 1 from coz_category_deal_rule_log a right join (select category_guid,max(id) as MID from coz_category_deal_rule_log group by category_guid) b on a.id=b.MID left join coz_category_deal_rule c on a.deal_rule_guid=c.guid where a.category_guid=t.guid and c.serve_fee_flag=''0'' and a.del_flag=''0'' and c.del_flag=''0'') and exists(select 1 from coz_category_deal_mode_log where category_guid=t.guid) and exists(select 1 from coz_category_supply_price_log where category_guid=t.guid) and exists(select 1 from coz_category_deal_deadline_log where category_guid=t.guid))  then ''1'' else ''0'' end as flag5
,(select price_mode from coz_category_deal_rule_log where category_guid=t.guid and del_flag=''0'' order by id desc limit 1) as priceMode
,''demand'' as sdFlag
,t5.btn_name_1
,t5.btn_name_2
,t5.btn_name_3
,t5.btn_name_4
,t.id
from
coz_category_info t
left join
coz_category_supplydemand t1
on t1.category_guid=t.guid
left join
coz_category_scene_tree t2
on t1.scene_tree_guid=t2.guid
left join
coz_cattype_sd_path t3
on t2.sd_path_guid=t3.guid
left join
coz_cattype_demand_path t4
on t3.demand_path_guid=t4.guid
left join
coz_cattype_supply_path t5
on t3.supply_path_guid=t5.guid
where t2.sd_path_guid=''{sdPathGuid}'' and t.del_flag=''0'' and (t.name like ''%{categoryName}%'' or ''{categoryName}''='''')
)t
)t
order by t.idx,t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

