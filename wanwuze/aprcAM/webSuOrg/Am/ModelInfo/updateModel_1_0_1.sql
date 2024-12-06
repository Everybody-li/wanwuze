-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-编辑型号-编辑型号名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 修改：修改型号名称，型号名称同个供方用户不可重复
-- ##Describe 表名：coz_category_supplier_am_model t1
-- ##CallType[ExSql]

-- ##input modelGuid char[36] NOTNULL;型号guid
-- ##input supplierGuid char[36] NOTNULL;供方品类guid
-- ##input modelName string[50] NOTNULL;型号名称(前端：需要调用aprcAM\webSuOrg\Am\ModelInfo\existsModelName_1_0_1判断型号名称是否存在，存在则弹窗提示并不可提交此次编辑)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

set @updateTime = now();

# 判断同个供方，型号名称是否重复
set @flag1=(select case when(exists(select 1 from coz_category_supplier_am_model where name='{modelName}' and supplier_guid='{supplierGuid}' and guid<>'{modelGuid}' and del_flag='0')) then '0' else '1' end)
;


# 型号名称不重复的时候 修改型号
update coz_category_supplier_am_model
set name='{modelName}'
,update_by='{curUserId}'
,update_time=@updateTime
where guid='{modelGuid}' and @flag1='1'
;
