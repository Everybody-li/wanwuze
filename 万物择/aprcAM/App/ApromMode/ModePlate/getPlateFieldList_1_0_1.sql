-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求页面加载-获取板块字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询
-- ##Describe 表名：coz_model_am_aprom_plate_field_formal t1,coz_model_am_aprom_plate_field_settings_formal t2,coz_model_am_aprom_plate_field_content_formal t3
-- ##CallType[QueryData]

-- 无需填写，不单独使用，和aprcAM\App\ApromMode\ModePlate\getPlateList_1_0_1一起使用，需要的出参见aprcAM\App\ApromMode\ModePlate\getPlateList_1_0_1


select
t.plate_guid as plateGuid
,t.guid as plateFieldGuid
,t.alias as plateFieldAlias
,t.norder as plateFieldNorder
,t1.operation as plateFieldOperation
,replace(t1.placeholder,'<br>',char(10)) as plateFieldPlaceholder
,t1.file_template as plateFieldFileTemplate
,t2.code as plateFieldContentCode
,case when exists(select 1 from coz_model_am_aprom_plate_field_content_formal where del_flag='0' and relate_field_guid=t.guid) then '1' else '0' end as relateFlag
from
coz_model_am_aprom_plate_field_formal t
inner join
coz_model_am_aprom_plate_field_settings_formal t1
on t1.plate_field_guid=t.guid
left join
coz_model_fixed_data t2
on t.content_fixed_data_guid=t2.guid
where
t.category_guid='{categoryGuid}' and t.del_flag='0' and t1.del_flag='0' and t1.cat_tree_code='{catTreeCode}'
order by t.norder