-- ##Title web-查询已添加的板块列表
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-查询已添加的板块列表
-- ##CallType[QueryData]

-- ##input catTreeCode string[50] NOTNULL;采购还是供应（supply：供应，demand：采购）
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input fixedDataBizType int[>=0] NOTNULL;业务类型：1：需求信息，2：报价信息，4：资质信息，必填
-- ##input plateFixedDataCode string[50] NULL;板块code，用于再次查询列表回显，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output plateGuid char[36] 板块guid;板块guid
-- ##output plateName string[50] 板块名称;板块名称
-- ##output plateAlias string[50] 板块别名;板块别名
-- ##output catTreeCode string[50] supply;采购还是供应（supply：供应，demand：采购）
-- ##output fixedDataCode string[50] 板块code;板块code
-- ##output norder int[>=0] 1;板块顺序
-- ##output hasSon int[>=0] 0;是否还有儿子节点（0：否，1-是）

select
t.category_guid as categoryGuid
,t.guid as plateGuid
,concat(t1.name,'(',t.alias,')') as plateName
,t.alias as plateAlias
,cat_tree_code as catTreeCode
,t.fixed_data_code as fixedDataCode
,t.norder
,case when exists(select 1 from coz_model_chat_plate_field where plate_guid=t.guid and del_flag='0') then '1' else '0' end as hasSon
from
coz_model_chat_plate t
inner join
coz_model_fixed_data t1
on t.fixed_data_code=t1.code
where 
t.cat_tree_code='{catTreeCode}' and t.category_guid='{categoryGuid}' and t.del_flag='0' and t1.del_flag='0' and t1.biz_type='{fixedDataBizType}' and (t.fixed_data_code like '%{plateFixedDataCode}%'or '{plateFixedDataCode}'='')
order by t.norder,t.id