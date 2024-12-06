-- ##Title web-查询可添加的板块列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-查询可添加的板块列表
-- ##CallType[QueryData]

-- ##input catTreeCode string[50] NOTNULL;采购还是供应（supply：供应，demand：采购）
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input bizType int[>=0] NOTNULL;业务类型：1-供需需求信息配置，2-供应报价信息配置，3-简历需求信息配置，4-采购资质信息配置，必填
-- ##input fixedDataBizType int[>=0] NOTNULL;业务类型：1：需求信息，2：报价信息，4：资质信息，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.code as fixedDataCode
,t1.name as fixedDataName
from
coz_model_fixed_data t1
where 
t1.del_flag='0' and t1.biz_type='{fixedDataBizType}' and t1.type='1' and not exists(select 1 from coz_model_chat_plate where cat_tree_code='{catTreeCode}' and category_guid='{categoryGuid}'  and del_flag='0' and fixed_data_code=t1.code)
order by t1.id

