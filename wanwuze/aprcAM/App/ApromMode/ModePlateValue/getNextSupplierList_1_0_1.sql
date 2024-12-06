-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-获取继续申请提交页面的供方型号列表(非二维码)
-- ##Author 卢文彪
-- ##CreateTime 2023-11-22
-- ##Describe 查非二维码的型号,t5按型号guid分组,取最大的,最大的是非二维码的
-- ##Describe 表名：coz_org_info t1,coz_category_supplier t2,coz_category_supplier_am_model t3, coz_category_supplier_am_model_price_plate t4,coz_category_am_modelprice_log t5
-- ##Describe 前端: 入参modelGuid根据接口获取: /Cache?Name=aprcBizParam&Key=amDeReq-{渠道需求guid},该接口数据包含了已经第一次提交申请的型号guid,前端需自行去掉该型号guid
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input modelGuid string[7200] NOTNULL;供方型号guid(支持多个)
-- ##input page int[>0] NOTNULL;页数
-- ##input size int[>0] NOTNULL;分页数量

-- ##output supplierGuid char[36] 品类供方guid;品类供方guid
-- ##output orgName string[100] ;品类供方机构名称(第一列字段名称),机构名称,最多展示6个字符,其余用省略号替代
-- ##output modelGuid char[36] 品类供方型号guid;品类供方型号guid
-- ##output modelName string[50] ;品类供方型号名称(第二列字段名称),采购路径是债权资金申请时:利息范围(固化字段code:f00063),其他路径:型号名称,最多展示5个字符,其余用省略号替代
-- ##output userId char[36] 品类供方用户id;品类供方用户id
-- ##output thirdColumnName string[50] ;第三列字段名称,采购路径是债权资金申请时:额度范围(固化字段code:f00064),其他路径:型号名称,最多展示5个字符,其余用省略号替代

select
supplierGuid
,case when(length(orgName)>5) then concat(left(orgName,5),'...') else orgName end as orgName
,modelGuid
,case when(length(modelName)>5) then concat(left(modelName,5),'...') else modelName end as modelName
,userId
,case when(length(thirdColumnName)>5) then concat(left(thirdColumnName,5),'...') else '' end as thirdColumnName
from
(
select
t2.guid as supplierGuid
,t1.name as orgName
,t3.guid as modelGuid
,case when ('{sdPathGuid}'='de7f5cd2-1f1e-11ed-afde-00163e2ca549') then ifnull((select plate_field_value from coz_category_supplier_am_model_price_plate where model_guid=t3.guid and plate_field_code='f00063' and del_flag='0' and status='1' limit 1),t3.name) else t3.name end as modelName
,t1.user_id as userId
,case when ('{sdPathGuid}'='de7f5cd2-1f1e-11ed-afde-00163e2ca549') then ifnull((select plate_field_value from coz_category_supplier_am_model_price_plate where model_guid=t3.guid and plate_field_code='f00064' and del_flag='0' and status='1' limit 1),'') else '' end as thirdColumnName
,t3.id
from
coz_org_info t1
inner join
coz_category_supplier t2
on t1.user_id=t2.user_id
inner join 
coz_category_supplier_am_model t3
on t3.supplier_guid=t2.guid
inner join 
(
select a.* from coz_category_am_modelprice_log a
right join
(select biz_guid,max(id) as MID from coz_category_am_modelprice_log where biz_guid in ({modelGuid}) and price_way='1' and del_flag='0' group by biz_guid) b
on 
a.id=b.MID
)t5
on t5.biz_guid=t3.guid
where
t3.guid in ({modelGuid}) and t1.del_flag='0'  and t2.del_flag='0'  and t3.del_flag='0' 
) t
order by t.id
Limit {compute:[({page}-1)*{size}]/compute},{size};

