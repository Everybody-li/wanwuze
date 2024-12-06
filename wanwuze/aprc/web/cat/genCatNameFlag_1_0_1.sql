-- ##Title web-品类定义-判断是否生成过品类名称_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-品类定义-判断是否生成过品类名称_1_0_1
-- ##CallType[QueryData]

-- ##input screenGuid char[36] NOTNULL;末级场景guid，必填

-- ##output genFlag int[>=0] 1;该场景生成品类名称标志(0：未生成，1：已生成)

select case when exists(select 1 from coz_category_supplydemand t left join coz_category_info t1 on t.category_guid=t1.guid where t.scene_tree_guid='{screenGuid}' and t.del_flag='0' and t1.del_flag='0') then '1' else '0' end as genFlag