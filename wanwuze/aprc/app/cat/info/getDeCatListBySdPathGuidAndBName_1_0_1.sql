-- ##Title app-采购-根据品类名称模糊查询品类列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-根据品类名称模糊查询品类列表_1_0_1
-- ##CallType[QueryData]

-- ##input sdPathGuid string[36] NOTNULL;采购供应路径关联guid，必填
-- ##input brandName string[200] NULL;品类名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填

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
,sdPathGuid
from
(
select
*
,case when (flag1=''1'' or flag2=''1'') then btn_name_2  when (flag3=''1'' or flag4=''1'') then btn_name_1 else btn_name_3 end as buttonStatusName
,case when (flag1=''1'' or flag2=''1'') then ''2''  when (flag3=''1'' or flag4=''1'') then ''1'' else ''3'' end as buttonStatus
from
(
select
t.guid as categoryGuid
,t.name as categoryName
,t.alias
,t.img
,t.mode as categoryMode
,case when(exists(select 1 from coz_app_user_permission where user_id=''{curUserId}'' and type=2 and del_flag=''0'' and status=''1'')) then ''1'' else ''0'' end as flag1
,case when(exists(select 1 from coz_app_user_permission_detail where biz_guid=t.guid and user_id=''{curUserId}'' and type=4 and del_flag=''0'')) then ''1'' else ''0'' end as flag2
,case when(exists(select 1 from coz_category_deal_rule_log a right join (select category_guid,max(id) as MID from coz_category_deal_rule_log group by category_guid) b on a.id=b.MID left join coz_category_deal_rule c on a.deal_rule_guid=c.guid where a.category_guid=t.guid and c.serve_fee_flag=''1''  and a.del_flag=''0''  and c.del_flag=''0'') and exists(select 1 from coz_category_deal_mode_log where category_guid=t.guid))  then ''1'' else ''0'' end as flag3
,case when(exists(select 1 from coz_category_deal_rule_log a right join (select category_guid,max(id) as MID from coz_category_deal_rule_log group by category_guid) b on a.id=b.MID left join coz_category_deal_rule c on a.deal_rule_guid=c.guid where a.category_guid=t.guid and c.serve_fee_flag=''0''  and a.del_flag=''0''  and c.del_flag=''0''))  then ''1'' else ''0'' end as flag4
,(select price_mode from coz_category_deal_rule_log where category_guid=t.guid and del_flag=''0'' order by id desc limit 1) as priceMode
,''demand'' as sdFlag
,t4.btn_name_1
,t4.btn_name_2
,t4.btn_name_3
,t.id
,t3.guid as sdPathGuid
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
where t2.sd_path_guid=''{sdPathGuid}'' and t.del_flag=''0'' and (exists(select 1 from coz_category_supplier_bill a inner join coz_category_supplier b on a.supplier_guid=b.guid where a.del_flag=''0'' and b.del_flag=''0'' and t.guid=b.category_guid and a.status= ''1'' and a.plate_field_code = ''f00052'' and a.plate_field_value like ''%{brandName}%'') or exists(select 1 from coz_category_supplier_model_plate a inner join coz_category_supplier_model b on a.model_guid=b.guid inner join coz_category_supplier c on b.supplier_guid=c.guid where a.del_flag=''0'' and b.del_flag=''0'' and c.del_flag=''0'' and t.guid=c.category_guid and a.status= ''1'' and a.plate_field_code = ''f00052'' and a.plate_field_value like ''%{brandName}%'') or ''{brandName}''='''')
)t
)t
group by categoryGuid,categoryName,alias,img,categoryMode,buttonStatus,buttonStatusName,sdFlag,priceMode,sdPathGuid
order by t.buttonStatus,t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

