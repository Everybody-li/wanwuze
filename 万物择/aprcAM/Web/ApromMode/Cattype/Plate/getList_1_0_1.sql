-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-板块配置-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 查询
-- ##Describe 表名：coz_model_am_aprom_plate t1,coz_model_fixed_data t2
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output plateGuid char[36] 板块guid;板块guid
-- ##output plateName string[50] 板块名称;板块名称
-- ##output plateAlias string[50] 板块别名;板块别名
-- ##output fixedDataCode string[50] 板块code;板块code
-- ##output norder int[>=0] 1;板块顺序
-- ##output hasSon int[>=0] 0;是否还有儿子节点（0：否，1-是）

select
t.category_guid as categoryGuid
,t.guid as plateGuid
,concat(t1.name,'(',t.alias,')') as plateName
,t.alias as plateAlias
,t.fixed_data_code as fixedDataCode
,t.norder
,case when exists(select 1 from coz_model_am_aprom_plate_field where plate_guid=t.guid and del_flag='0') then '1' else '0' end as hasSon
from
coz_model_am_aprom_plate t
inner join
coz_model_fixed_data t1
on t.fixed_data_code=t1.guid
where 
t.category_guid='{categoryGuid}' and t.del_flag='0' and t1.del_flag='0'
order by t.norder