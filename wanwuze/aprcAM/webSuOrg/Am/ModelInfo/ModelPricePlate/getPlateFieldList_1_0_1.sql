-- ##Title  web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-创建型号产品介绍-获取板块字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询
-- ##Describe 表名：coz_model_am_aprom_plate_field_formal t1,coz_model_am_aprom_plate_field_settings_formal t2,coz_model_am_aprom_plate_field_content_formal t3
-- ##CallType[QueryData]

-- 无需填写，不单独使用，和aprcAM\App\ApromMode\ModePlate\getPlateList_1_0_1一起使用，需要的出参见aprcAM\App\ApromMode\ModePlate\getPlateList_1_0_1


select
t.plate_guid as plateGuid
,t.guid as plateFieldGuid
,case when exists(select 1 from coz_model_am_aprom_plate_field_content_formal where del_flag='0' and relate_field_guid=t.guid) then '1' else '0' end as relateFlag
,case when(t.source=2) then t.alias else (select name from coz_model_fixed_data where guid=t.name) end as plateFieldName
,t.alias as plateFieldAlias
,t.norder as plateFieldNorder
,t.operation as plateFieldOperation
,t.placeholder as plateFieldPlaceholder
,t.file_template as plateFieldFileTemplate
,t3.code as plateFieldContentCode
,'0' as relateFlag
,t2.code as plateFieldCode
-- ,case when(t2.code='c00008' or t2.code='c00009' or t2.code='c00010' or t2.code='c00011' or t2.code='c00012' or t2.code='c00020' or t2.code='c00021' or t2.code='c00022' or t2.code='c00023' or t2.code='c00024') then uuid() else '' end as fieldBizGuid
,uuid() as fieldBizGuid
from
{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getTableNamePrefixByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}_plate_field_formal t
left join
coz_model_fixed_data t2
on t.name=t2.guid and t2.del_flag='0'
left join
coz_model_fixed_data t3
on t.content_fixed_data_guid=t3.guid and t3.del_flag='0'
where
t.biz_guid='{bizGuid}' and t.del_flag='0'
order by t.norder