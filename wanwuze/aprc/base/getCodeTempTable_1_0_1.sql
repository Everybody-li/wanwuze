-- ##Title 查询字段内容多选-业务数据临时表名
-- ##Author 卢文彪
-- ##CreateTime 2023-11-07
-- ##Describe
-- ##CallType[QueryData]

-- ##iutput bizCode string[11] NOTNULL;业务code


# c00020-国标行业,c00024-企业业务类型
# c00008-行政区域国家/地区, c00009-行政区域省级, c00010-行政区域市级, c00011-行政区域区县级, c00012-行政区域镇级,c00021-行政区域村委,c00022-行政区域(全球至区县),c00023-行政区域（无行政区域区县级）,
select 
case
    when '{bizCode}' = 'c00024' then 'coz_biz_city_otherbiz_temp'
    when '{bizCode}' = 'c00020' then 'coz_biz_city_otherbiz_temp'
    when '{bizCode}' = 'c00023' then 'coz_biz_city_code_hasnone_temp'
 when '{bizCode}' = 'c00022' then 'coz_biz_city_code_hasglobal_temp'
else 'coz_biz_city_code_temp' end as codeTable;


