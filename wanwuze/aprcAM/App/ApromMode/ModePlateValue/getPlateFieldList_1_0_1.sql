-- ##Title  app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-渠道供应-办理申请提交-获取板块字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-13
-- ##Describe 查询
-- ##Describe 表名：coz_model_am_modelprice_de_plate_field_formal t1,coz_model_am_modelprice_de_plate_field_content_formal t2
-- ##CallType[QueryData]

-- 无需填写，不单独使用，和aprcAM\App\ApromMode\ModelPricePlate\getPlateList_1_0_1一起使用，需要的出参见aprcAM\App\ApromMode\ModelPricePlate\getPlateList_1_0_1


select
t1.plate_guid as plateGuid
,t1.guid as plateFieldGuid
,t1.alias as plateFieldAlias
,t1.norder as plateFieldNorder
,t1.operation as plateFieldOperation
,replace(t1.placeholder,'<br>',char(10)) as plateFieldPlaceholder
,t2.code as plateFieldCode
,case when (t1.file_template='') then '' else concat('aprcAM/Web/Suprice/PLATEFIELD/2/',left(t1.file_template,1),'/',t1.file_template) end as plateFieldFileTemplate
,t2.code as plateFieldContentCode
from
coz_model_am_modelprice_de_plate_field_formal t1
left join
coz_model_fixed_data t2
on t1.content_fixed_data_guid=t2.guid and t2.del_flag='0'
where
t1.biz_guid='{modelGuid}' and t1.del_flag='0' 
order by t1.norder


