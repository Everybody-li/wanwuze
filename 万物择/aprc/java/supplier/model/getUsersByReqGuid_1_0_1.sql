-- ##Title 需求-型号-批量查询供方
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-型号-批量查询供方
-- ##CallType[QueryData]

-- ##input requestGuid string[500] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select t.guid                                         as supplierGuid
     , t.user_id                                      as userId
     , t1.guid                                        as modelGuid
     , CONCAT('{ChildRows_aprc\\java\\supplier\\model\\getModelPlates_1_0_1:supplierGuid=''', t.guid,
              ''' and model_guid=''', t1.guid, '''}') as `plates`
from coz_category_supplier t
         inner join coz_category_supplier_model t1 on t1.supplier_guid = t.guid
         inner join sys_weborg_user t2 on t.user_id = t2.guid
         left join coz_demand_request_supply rs on rs.model_guid = t1.guid and rs.request_guid = '{requestGuid}'
where rs.guid is null
  and t.del_flag = '0'
  and t.range_flag = 1
  and t2.status = '0'
  and t2.del_flag = '0'
  and t.user_type = '2'
  and t1.del_flag = '0'