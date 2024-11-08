-- ##Title web-查询字段值配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段值配置列表
-- ##CallType[QueryData]



-- ##CustomFormatterColumns[{column:[value]/column}{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\app\demand\dReq\plates\codeToPathName_1_0_1&DBC=w_a&{Value}]/url}];


select {file[aprc/app/demand/dReq/plates/codeCondition_1_0_1.sql]/file} as value
     , t.guid                                                  as quaUserPlatelGuid
     , t.plate_field_formal_guid                               as fieldGuid
from coz_demand_request_price_plate t
where t.request_price_guid = '{requestPriceGuid}'
  and t.del_flag = '0';
