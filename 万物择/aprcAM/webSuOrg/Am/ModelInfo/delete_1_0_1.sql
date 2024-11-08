-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-删除型号
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 删除：删除这个型号及所有子表信息
-- ##Describe 表名：coz_category_supplier_am_model t1,coz_category_supplier_am_model_plate t2,coz_category_supplier_am_model_price_plate t3
-- ##CallType[ExSql]

-- ##input modelGuid char[36] NOTNULL;型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id


update coz_category_supplier_am_model_price_plate
set del_flag='2'
  , update_by='{curUserId}'
  , update_time=now()
where model_guid = '{modelGuid}'
;
update coz_category_supplier_am_model_plate
set del_flag='2'
  , update_by='{curUserId}'
  , update_time=now()
where model_guid = '{modelGuid}'
;
update coz_category_supplier_am_model
set del_flag='2'
  , update_by='{curUserId}'
  , update_time=now()
where guid = '{modelGuid}'
;
# 删除型号-非二维码方式-采购需求信息和供应报价信息的板块字段等关联关系
delete
from coz_model_am_clone_guid
where cattype_guid = '{modelGuid}';