-- ##Title web-供应-按单-查询是否可以新增型号
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应-按单-查询是否可以新增型号
-- ##CallType[QueryData]

-- ##input supplierGuid char[36] NOTNULL;供方品类表guid（app自己生成uuid），必填
-- ##input modelName string[50] NOTNULL;型号名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
opFlag
,case when(opFlag='1') then '' else '当前品类已经存在型号名称：【{modelName}】请修改后再操作' end as msg
from
(
select
case when (exists(select 1 from coz_category_supplier_model where name='{modelName}' and supplier_guid='{supplierGuid}' and del_flag='0')) then '0' else '1' end as opFlag
)t
;