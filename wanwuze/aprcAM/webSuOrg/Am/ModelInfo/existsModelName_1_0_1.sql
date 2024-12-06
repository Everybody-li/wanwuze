-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-判断型号名称是否存在
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##Describe 表名：coz_category_supplier_am_model t1
-- ##CallType[QueryData]

-- ##input modelName string[50] NOTNULL;型号名称
-- ##input modelGuid string[50] NOTNULL;型号guid
-- ##input supplierGuid string[50] NOTNULL;供方品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output existsFlag enum[0,1] 0-不存在，1-存在（前端：存在则不可创建型号，不存在才可以创建）;

select case when(exists(select 1 from coz_category_supplier_am_model where name='{modelName}' and supplier_guid='{supplierGuid}' and guid<>'{modelGuid}' 
and del_flag='0')) then '1' else '0' end as existsFlag
;
