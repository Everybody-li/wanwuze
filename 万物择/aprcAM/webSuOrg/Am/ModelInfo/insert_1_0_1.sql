-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-创建型号
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 新增：同个供方，型号名称不可重复
-- ##Describe 表名：coz_category_supplier_am_model t1
-- ##CallType[ExSql]

-- ##input modelName string[50] NOTNULL;型号名称
-- ##input modelGuid char[36] NULL;前端通过获取guid接口获取
-- ##input supplierGuid string[50] NOTNULL;供方品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

insert into coz_category_supplier_am_model
(
guid
,supplier_guid
,name
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
case when('{modelGuid}'='') then uuid() else '{modelGuid}' end
,'{supplierGuid}'
,'{modelName}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_category_supplier t
where t.guid='{supplierGuid}' 
and not exists(select 1 from coz_category_supplier_am_model where name='{modelName}' and supplier_guid='{supplierGuid}' and del_flag='0')
;
