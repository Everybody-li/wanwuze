-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-供方信息-查询供方详情-板块字段内容值
-- ##Author 卢文彪
-- ##CreateTime 2023-08-02
-- ##Describe 表名：coz_category_supplier_am_model_price_plate t1
-- ##CallType[QueryData]

-- ##CustomFormatterColumns[{column:[value]/column}{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\app\demand\dReq\plates\codeToPathName_1_0_1&DBC=w_a&{Value}]/url}];


select t.plate_field_formal_guid                               as plateFieldGuid
     , {file[aprc/app/demand/dReq/plates/codeCondition_1_0_1.sql]/file} as value
from coz_category_supplier_am_model_price_plate t
where t.model_guid = '{modelGuid}'
  and t.del_flag = '0'
  and status = '1'
