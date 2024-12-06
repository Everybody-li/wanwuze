-- ##Title 查询市列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 查询市列表
-- ##CallType[QueryData]

-- ##iutput bizCode string[11] NOTNULL;业务code


# c00020-国标行业,c00024-企业业务类型
# c00008-行政区域国家/地区, c00009-行政区域省级, c00010-行政区域市级, c00011-行政区域区县级, c00012-行政区域镇级,c00021-行政区域村委,c00022-行政区域(全球至区县),c00023-行政区域（无行政区域区县级）,
select case
           when '{bizCode}' = 'c00024' then 'sys_enttype_code'
           when '{bizCode}' = 'c00020' then 'sys_isic_code'
           when '{bizCode}' = 'c00023' then 'sys_city_code_hasnone'
           when '{bizCode}' = 'c00022' then 'sys_city_code_hasglobal'
           else 'sys_city_code' end as codeTable;

