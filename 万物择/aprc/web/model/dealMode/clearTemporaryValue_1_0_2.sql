-- ##Title 清除生成品类产生的临时值
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 清除生成品类产生的临时值
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

# 修改品类名称的供需信息主表的发布时间为当前时间
update coz_category_deal_mode t
set publish_time=now()
  ,publish_flag='2'
,update_time = now()
,update_by = '{curUserId}'
where category_guid = '{categoryGuid}'
;

# 将品类名称的字段内容表的临时数据改为已发布-草稿表
update coz_model_plate_field_content t
    left join coz_model_plate_field t1 on t.plate_field_guid = t1.temp_guid and t.category_guid = t1.category_guid
set t.plate_field_guid=t1.guid
  , t.temp_guid=null
  , t.del_flag='0'
  , t.publish_flag='2'
,t.update_time = now()
,t.update_by = '{curUserId}'
where (t.temp_guid is not null and t.temp_guid <> '')
  and t.del_flag = '2'
  and t.biz_type = '1'
  and t.category_guid = '{categoryGuid}'
  and t1.guid is not null
;

# 将品类名称的字段表的临时数据改为已发布-草稿表
update coz_model_plate_field t
    left join coz_model_plate t1 on t.plate_guid = t1.temp_guid and t.category_guid = t1.category_guid
set t.plate_guid=t1.guid
  , t.temp_guid=null
  , t.del_flag='0'
  , t.publish_flag='2'
  , t.publish_time=now()
,t.update_time = now()
,t.update_by = '{curUserId}'
where (t.temp_guid is not null and t.temp_guid <> '')
  and t.del_flag = '2'
  and t.biz_type = '1'
  and t.category_guid = '{categoryGuid}'
  and t1.guid is not null
;

# 将品类名称的板块表的临时数据改为已发布-草稿表
update coz_model_plate
set temp_guid=null
  , del_flag='0'
  , publish_flag='2'
  , publish_time=now()
,update_time = now()
,update_by = '{curUserId}'
where (temp_guid is not null and temp_guid <> '')
  and del_flag = '2'
  and biz_type = '1'
  and category_guid = '{categoryGuid}'
;

# 将品类的供方字段的demand_pf_formal_guid值赋值为需方的字段guid-草稿表
update
 coz_model_plate_field t1
         inner join coz_model_plate_field t2 on t1.category_guid = t2.category_guid
set t2.demand_pf_guid = t1.guid
,t1.update_time = now()
,t1.update_by = '{curUserId}'
where t1.cat_tree_code = 'demand'
  and t2.cat_tree_code = 'supply'
  and t1.biz_type = '1'
  and t2.biz_type = '1'
  and t1.name = t2.name
  and t1.del_flag = '0'
  and t2.del_flag = '0'
  and t1.category_guid = '{categoryGuid}';


# 将品类名称的板块字段内容表的临时数据改为生效-正式表
update coz_model_plate_field_content_formal t
    left join coz_model_plate_field_formal t1 on t.plate_field_formal_guid = t1.temp_guid and
                                                 t.category_guid = t1.category_guid
set t.plate_field_formal_guid=t1.guid
  , t.temp_guid=null
  , t.del_flag='0'
,t.update_time = now()
,t.update_by = '{curUserId}'
where (t.temp_guid is not null and t.temp_guid <> '')
  and t.del_flag = '2'
  and t.biz_type = '1'
  and t.category_guid = '{categoryGuid}'
  and t1.guid is not null
;

# 将品类名称的板块字段表的临时数据改为生效-正式表
update coz_model_plate_field_formal t
    left join coz_model_plate_formal t1 on t.plate_formal_guid = t1.temp_guid and t.category_guid = t1.category_guid
set t.plate_formal_guid=t1.guid
  , t.temp_guid=null
  , t.del_flag='0'
,t.update_time = now()
,t.update_by = '{curUserId}'
where (t.temp_guid is not null and t.temp_guid <> '')
  and t.del_flag = '2'
  and t.biz_type = '1'
  and t.category_guid = '{categoryGuid}'
  and t1.guid is not null
;

# 将品类名称的板块表的临时数据改为生效-正式表
update coz_model_plate_formal
set temp_guid=null
  , del_flag='0'
,update_time = now()
,update_by = '{curUserId}'
where (temp_guid is not null and temp_guid <> '')
  and del_flag = '2'
  and biz_type = '1'
  and category_guid = '{categoryGuid}'
;


# 将品类的供方字段的demand_pf_formal_guid值赋值为需方的字段guid-正式表
update
 coz_model_plate_field_formal t1
         inner join coz_model_plate_field_formal t2 on t1.category_guid = t2.category_guid
set t2.demand_pf_formal_guid = t1.guid
,t1.update_time = now()
,t1.update_by = '{curUserId}'
where t1.cat_tree_code = 'demand'
  and t2.cat_tree_code = 'supply'
  and t1.biz_type = '1'
  and t2.biz_type = '1'
  and t1.name = t2.name
  and t1.del_flag = '0'
  and t2.del_flag = '0'
  and t1.category_guid = '{categoryGuid}';





