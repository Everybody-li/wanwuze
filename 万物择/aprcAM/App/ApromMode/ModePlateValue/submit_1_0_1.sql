-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-供方信息-产品信息详情-办理申请提交-非二维码方式
-- ##Author 卢文彪
-- ##CreateTime 2023-08-02
-- ##Describe 保存需方办理申请需求及需求内容：新增t1，t2，入参没有的就放空，
-- ##Describe 将需方需求和选中的供方(入参供方)保存起来，按严格匹配规则类型保存：根据入参supplierGuid 新增t3(t3.request_guid=t1.guid)，t4(t4.request_guid=t1.guid,t4.request_supply_guid=t3.guid)
-- ##Describe 将需方需求和除入参选中的供方以外的其他供方，按系统推荐保存根据入参 t4(t4.request_guid=t1.guid,t4.request_supply_guid=空)，入参没有的就放空，
-- ##Describe 表名：coz_demand_request t1,coz_demand_request_plate t2，coz_demand_request_supply t3,coz_demand_request_match_notice t4,coz_category_supplier t5
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;需求guid，前端自行获取一个
-- ##input requestSupplyGuid char[36] NOTNULL;需求推荐guid，前端自行获取一个
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input supplierGuid char[36] NOTNULL;供方用户品类guid
-- ##input modelGuid char[36] NOTNULL;供方用户品类型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id


set @serveFeeFlag = '0';
select drl.serve_fee_flag
into @serveFeeFlag
from (select category_guid, serve_fee_flag
      from coz_category_deal_rule_log
      where category_guid = '{categoryGuid}'
        and del_flag = '0'
      order by id desc
      limit 1) drl
         inner join (select category_guid, charge_value
                     from coz_category_service_fee_log
                     where category_guid = '{categoryGuid}'
                       and del_flag = '0'
                     order by id desc
                     limit 1) sfl on drl.category_guid = sfl.category_guid
where serve_fee_flag = '1';

insert into coz_demand_request
( guid
, parent_guid
, parent_request_price_guid
, supply_assign_rule_type
, all_parent_id
, sd_path_guid
, sd_path_all_name
, cattype_guid
, cattype_name
, category_guid
, category_name
, category_mode
, category_img
, category_alias
, category_time
, price_mode
, serve_fee_flag
, deal_rule_log_guid
, user_id
, user_name
, user_phone
, longitude
, latitude
, need_deliver_flag
, del_flag
, create_by
, create_time
, update_by
, update_time)
select '{requestGuid}'  as guid
     , ''               as parentGuid
     , ''               as parent_request_price_guid
     , '0'              as supply_assign_rule_type
     , ''               as allpar
     , '{sdPathGuid}'   as sdPathGuid
     , ''               as sdPathAllName
     , t.cattype_guid   as cattypeGuid
     , t.cattype_name   as cattypeName
     , t.guid           as categoryGuid
     , t.name           as categoryName
     , 3
     , t.img
     , t.alias          as categoryAlias
     , t.create_time    as categoryTime
     , '1'              as priceMode
     , @serveFeeFlag    as severFeeFlag
     , @dealRuleLogGuid as dealRuleLogGuid
     , t1.guid          as userId
     , t1.user_name     as userName
     , t1.phonenumber   as userPhone
     , ''               as longitude
     , ''               as latitude
     , '0'              as needDeliverFlag
     , 0                as del_flag
     , '{curUserId}'    as create_by
     , now()            as create_time
     , '{curUserId}'    as update_by
     , now()            as update_time
from coz_category_info t
         inner join
         (select * from sys_app_user where guid = '{curUserId}') t1
         on 1 = 1
where t.guid = '{categoryGuid}'
  and t.del_flag = '0'
  and t1.del_flag = '0'
;
insert into coz_demand_request_supply
( guid
, request_guid
, supplier_guid
, model_guid
, user_name
, user_phone
, del_flag
, create_by
, create_time
, update_by
, update_time
, model_name)
select '{requestSupplyGuid}' as guid
     , '{requestGuid}'       as request_guid
     , '{supplierGuid}'      as supplier_guid
     , '{modelGuid}'         as model_guid
     , t3.name               as userName
     , t3.phonenumber        as userPhone
     , '0'                   as del_flag
     , '{curUserId}'         as create_by
     , now()                 as create_time
     , '{curUserId}'         as update_by
     , now()                 as update_time
     , t1.name               as model_name
from coz_category_supplier_am_model t1
         inner join coz_category_supplier t2 on t1.supplier_guid = t2.guid
         inner join coz_org_info t3 on t2.user_id = t3.user_id
where t1.guid = '{modelGuid}'
  and t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
;
insert into coz_demand_request_match_notice
( guid
, supply_path_guid
, user_id
, request_guid
, request_supply_guid
, model_guid
, notice_setting_guid
, recommend_type
, del_flag
, create_by
, create_time
, update_by
, update_time)
select uuid()
     , (select supply_path_guid from coz_cattype_sd_path where guid = '{sdPathGuid}')
     , t.user_id
     , '{requestGuid}'
     , '{reqeustSupplyGuid}'
     , '{modelGuid}'
     , ''
     , '1'
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_category_supplier t
where t.guid = '{supplierGuid}'
;

insert into coz_demand_request_match_notice
( guid
, supply_path_guid
, user_id
, request_guid
, request_supply_guid
, model_guid
, notice_setting_guid
, recommend_type
, del_flag
, create_by
, create_time
, update_by
, update_time)
select uuid()
     , (select supply_path_guid from coz_cattype_sd_path where guid = '{sdPathGuid}')
     , t.user_id
     , '{requestGuid}'
     , ''
     , '{modelGuid}'
     , ''
     , '2'
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_category_supplier t
where t.category_guid = '{categoryGuid}'
  and t.guid <> '{supplierGuid}'
;
