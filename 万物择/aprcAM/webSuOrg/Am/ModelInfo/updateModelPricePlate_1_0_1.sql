-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式--编辑型号产品介绍-修改板块字段内容
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 修改，值与表里不同时才修改
-- ##Describe 表名：coz_category_supplier_am_model_price_plate t1
-- ##CallType[ExSql]

-- ##input plateFieldValueGuid char[36] NOTNULL;型号板块字段内容值guid
-- ##input plateFieldValue string[100] NOTNULL;型号板块字段内容值
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_category_supplier_am_model_price_plate
set plate_field_value='{plateFieldValue}'
where guid='{plateFieldValueGuid}'
;
