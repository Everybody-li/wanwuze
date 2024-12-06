-- ##Title web-判断供方必填的固化字段名称是否已经配置
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-判断供方必填的固化字段名称是否已经配置
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input fixedDataGuid char[36] NOTNULL;采购方正在添加的固化字段名称固化信息表guid，必填
-- ##input bizType int[>=0] NOTNULL;业务类型：1-供需需求信息配置，，3-简历需求信息配置，必填

-- ##output demandName string[50] 需方已经添加的字段名称;需方已经添加的字段名称
-- ##output supplyName string[50] 供方未添加需方已添加的固化的对应供应名称固化库guid;供方未添加需方已添加的固化的对应供应名称固化库guid
-- ##output fixedDataGuid char[36] 需方已经添加的字段名称;需方已经添加的字段名称

select
'' as demandName
,'' as supplyName
,'' as fixedDataGuid
from
sys_dept
where 1=2