-- ##Title web-查询字段值配置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询字段值配置列表
-- ##CallType[QueryData]


-- ##input code string[36] NOTNULL;行政区域code/固化字段内容值guid
-- ##input selectColumnName enum[path_name,value,name] NOTNULL;查询数据列名称
-- ##input whereColumnName enum[code,guid] NOTNULL;过滤数据列名称
-- ##input tableName enum[sys_city_code,sys_city_code_hasnone,sys_city_code_hasglobal,sys_enttype_code,sys_isic_code] NOTNULL;数据来源表


select *
from (select {selectColumnName}
      from {tableName}
      where {whereColumnName} = '{code}'
      union all
      select '{code}' as path_name) t
limit 1;


