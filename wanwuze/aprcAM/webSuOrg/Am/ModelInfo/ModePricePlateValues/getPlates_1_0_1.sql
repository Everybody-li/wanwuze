-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-查询型号详情-获取板块列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询：复合接口，嵌套结构，仅需返回2层
-- ##Describe 表名：coz_category_supplier_am_model_plate
-- ##Describe 排序：板块的顺序升序
-- ##CallType[QueryData]

select
t.model_guid as modelGuid
,t.plate_formal_guid as plateGuid
,t.plate_formal_alias as plateAlias
,t.plate_norder as plateNorder
,CONCAT('{ChildRows_aprcAM\\webSuOrg\\Am\\ModelInfo\\ModePricePlateValues\\getPlateFieldList_1_0_1:plateGuid=''',t.plate_formal_guid,'''}') as `fields`
from
coz_category_supplier_am_model_price_plate t
where 
t.model_guid='{modelGuid}' and t.del_flag='0'  and t.status ='1'
group by t.model_guid,t.plate_formal_guid,t.plate_formal_alias,t.plate_norder