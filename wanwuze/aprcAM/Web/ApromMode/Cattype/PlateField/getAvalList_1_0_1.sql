-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-字段名称配置-查询可添加的字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 查询当前品类未添加的字段名称列表
-- ##Describe 表名：coz_model_am_aprom_plate t1,coz_model_fixed_data t2
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input fixedDataName string[20] NULL;固化字段名称，非必填(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output fixedDataCode string[6] 固化字段名称code;固化字段名称code
-- ##output fixedDataName string[20] 固化字段名称;固化字段名称

select
t1.guid as fixedDataCodeGuid
,t1.code as fixedDataCode
,t1.name as fixedDataName
from
coz_model_fixed_data t1
where 
t1.del_flag='0' and (t1.type='2') and not exists(select 1 from coz_model_am_aprom_plate_field where category_guid='{categoryGuid}' and del_flag='0' and name=t1.guid)
 and (t1.name like '%{fixedDataName}%' or '{fixedDataName}'='')
order by t1.id
Limit {compute:[({page}-1)*{size}]/compute},{size};