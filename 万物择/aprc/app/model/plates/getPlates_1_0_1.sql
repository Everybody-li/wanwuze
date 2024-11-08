-- ##Title web-查询板块配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询板块配置列表
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input bizType int[>=0] NOTNULL;业务类型（1：供需信息，2：供应报价，4：采购资质）
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output bizType int[>=0] 1;业务类型（1：供需信息，2：供应报价，4：采购资质）
-- ##output name string[50] 板块名称;板块名称
-- ##output norder int[>=0] 1;板块名称顺序
-- ##output alias string[50] 板块别名;板块别名
-- ##output plateFDCode string[50] 固化板块code;固化板块code(非固化的值为空)
-- ##output plateGuid char[36] 板块guid;板块guid

select
t.biz_type as bizType
,t.norder
,t.alias
,t.guid as plateGuid
,t.fixed_data_code as plateFDCode
,CONCAT('{ChildRows_aprc\\app\\model\\plates\\getPlateFields_1_0_1:plateGuid=''',t.GUID,'''}') as `field`
from
coz_model_plate_formal t
where t.del_flag='0' and t.biz_type='{bizType}' and t.cat_tree_code='{catTreeCode}' and t.category_guid='{categoryGuid}'
order by t.norder,t.id