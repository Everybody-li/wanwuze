-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-板块配置-查询可添加的板块列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 查询当前品类未添加的板块列表
-- ##Describe 表名：coz_model_am_aprom_plate t1,coz_model_fixed_data t2
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.guid as fixedDataCodeGuid
,t1.code as fixedDataCode
,t1.name as fixedDataName
from
coz_model_fixed_data t1
where 
t1.del_flag='0' and t1.type='1' and t1.biz_type='1' and not exists(select 1 from coz_model_am_aprom_plate where category_guid='{categoryGuid}' and del_flag='0' and fixed_data_code=t1.guid)
order by t1.id

