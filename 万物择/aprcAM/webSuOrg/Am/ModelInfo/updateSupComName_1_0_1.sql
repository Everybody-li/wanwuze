-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-编辑型号产品介绍-修改供应主体信息
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 修改
-- ##Describe 表名：coz_category_supplier_am_model t1
-- ##CallType[ExSql]

-- ##input supplyCompanyName string[50] NOTNULL;供应主体（卖家公司）
-- ##input modelGuid char[36] NOTNULL;型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

set @updateTime = now();

update coz_category_supplier_am_model
set supply_company_name='{supplyCompanyName}'
,update_by='{curUserId}'
,update_time= @updateTime 
where guid='{modelGuid}'
;
