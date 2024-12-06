-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-查询提交的渠道需求内容详情-板块字段内容列表
-- ##Author lith
-- ##CreateTime 2023-12-04
-- ##Describe 表名：coz_aprom_pre_demand_request,coz_aprom_pre_demand_request_plate
-- ##CallType[QueryData]

-- ##input preRequestGuid char[36] NOTNULL;渠道需求guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##CustomFormatterColumns[{column:[value]/column}{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\app\demand\dReq\plates\codeToPathName_1_0_1&DBC=w_a&{Value}]/url}];

select t.plate_field_formal_guid                                         as plateFieldGuid
     , t.plate_field_value                                               as `key`
     , t.plate_field_relate_field_guid                                   as plateFieldRelateFieldGuid
     , {file[aprc/app/demand/dReq/plates/codeCondition_1_0_1.sql]/file} as value
from coz_aprom_pre_demand_request_plate t
where t.request_guid = '{preRequestGuid}'
  and t.del_flag = '0'
  and t.status = '1'
