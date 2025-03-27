-- ##Title 公共脚本-取数据源-根据固化字段内容code值做判断
-- ##Author lith
-- ##CreateTime 2023-11-09
-- ##Describe
-- ##CallType[QueryData]


 case
           when length(t.plate_field_content_gc) > 2 and substring(t.plate_field_content_gc,1,2) = 'c2' then concat('code=', t.plate_field_value,
                                                                '&selectColumnName=`value`&whereColumnName=t2.guid&tableName=coz_model_fixed_data t1
               inner join coz_model_fixed_data_value t2 on t1.guid = t2.fixed_data_guid')
           when t.plate_field_content_gc = 'c00020' then concat('code=', t.plate_field_value,
                                                                '&selectColumnName=path_name&whereColumnName=code&tableName=sys_isic_code')
           when t.plate_field_content_gc = 'c00024' then concat('code=', t.plate_field_value,
                                                                '&selectColumnName=path_name&whereColumnName=code&tableName=sys_enttype_code')
           when t.plate_field_content_gc = 'c00016' then concat('code=', t.plate_field_value,
                                                                '&selectColumnName=name&whereColumnName=guid&tableName=coz_category_info')
           when t.plate_field_content_gc = 'c00022' then concat('code=', t.plate_field_value,
                                                                '&selectColumnName=path_name&whereColumnName=code&tableName=sys_city_code_hasglobal')
           when t.plate_field_content_gc = 'c00023' then concat('code=', t.plate_field_value,
                                                                '&selectColumnName=path_name&whereColumnName=code&tableName=sys_city_code_hasnone')
           when (t.plate_field_content_gc = 'c00008' or t.plate_field_content_gc = 'c00009' or
                 t.plate_field_content_gc = 'c00010' or t.plate_field_content_gc = 'c00011' or
                 t.plate_field_content_gc = 'c00012' or t.plate_field_content_gc = 'c00021') then concat('code=',
                                                                                                         t.plate_field_value,
                                                                                                         '&selectColumnName=path_name&whereColumnName=code&tableName=sys_city_code')
          when  (t.plate_field_code in ('f00051','f00062')) then concat('code=',
                       round(t.plate_field_value/100,2),
                       '&selectColumnName=path_name&whereColumnName=code&tableName=sys_city_code_hasnone')
          else concat('code=',
                       t.plate_field_value,
                       '&selectColumnName=path_name&whereColumnName=code&tableName=sys_city_code') end


