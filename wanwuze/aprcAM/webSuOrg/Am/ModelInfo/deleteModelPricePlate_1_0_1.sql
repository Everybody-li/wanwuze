-- ##Title web机构-审批模式-型号模式-需求范围管理-需求范围设置-型号模式-编辑型号产品介绍-型号板块内容-删除
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 删除
-- ##Describe coz_category_supplier_am_model_price_plate
-- ##CallType[ExSql]

-- ##input modelGuid char[36] NOTNULL;型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id


update coz_category_supplier_am_model_price_plate
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where model_guid='{modelGuid}'
;
