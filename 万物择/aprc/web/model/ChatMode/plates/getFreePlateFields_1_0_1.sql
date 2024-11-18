-- ##Title web-查询可添加的库字段名称列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-查询可添加的库字段名称列表
-- ##CallType[QueryData]

-- ##input catTreeCode string[50] NOTNULL;采购还是供应（supply：供应，demand：采购）
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input bizType int[>=0] NOTNULL;业务类型：1-供需需求信息配置，2-供应报价信息配置，3-简历需求信息配置，4-采购资质信息配置，必填
-- ##input name string[50] NULL;板块名称字段名称（模糊搜索），非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.code as fixedDataCode
,t1.name as fixedDataName
from
coz_model_fixed_data t1
where 
t1.del_flag='0' and (t1.biz_type='1' or t1.biz_type='2' or t1.biz_type='4' or t1.biz_type='7' or t1.biz_type='9') and (t1.type='2') and not exists(select 1 from coz_model_chat_plate_field where cat_tree_code='{catTreeCode}' and category_guid='{categoryGuid}' and biz_type='{bizType}' and del_flag='0' and name=t1.code) and (t1.name like '%{name}%' or '{name}'='')
order by t1.id

