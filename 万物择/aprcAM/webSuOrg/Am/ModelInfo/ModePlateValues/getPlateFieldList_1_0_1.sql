-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-查询型号详情-获取板块字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 查询
-- ##Describe 表名：coz_category_supplier_am_model_plate
-- ##Describe 排序：字段名称的顺序升序
-- ##CallType[QueryData]

# 查询品类guid
set @categoryGuid = '';
select apfield.category_guid
into @categoryGuid
from coz_model_am_aprom_plate_field_formal apfield
         inner join coz_category_supplier_am_model_plate t on apfield.guid = t.plate_field_formal_guid
where t.model_guid = '{modelGuid}'
# where t.model_guid = 'd827b727-aacf-11ee-814e-00163e2ca549'
  and t.del_flag = '0'
  and t.status = '1'
limit 1;

# select t.plate_formal_guid                as plateGuid
#      , t.plate_field_formal_guid          as plateFieldGuid
#      , t.plate_field_formal_alias         as plateFieldAlias
#      , t.plate_field_norder               as plateFieldNorder
#      , t.operation                        as plateFieldOperation
#      , t.plate_field_content_gc           as plateFieldContentCode
#      , t.plate_field_value_remark         as fieldBizGuid
#      , CONCAT(
#         '{ChildRows_aprcAM\\webSuOrg\\Am\\ModelInfo\\ModePlateValues\\getPlateFieldValuesList_1_0_1:plateFieldGuid=''',
#         t.plate_field_formal_guid, '''}') as `values`
# from coz_model_am_aprom_plate_field_formal apfield
#          left join coz_category_supplier_am_model_plate t on apfield.guid = t.plate_field_formal_guid
# where apfield.category_guid = @categoryGuid
#   and t.del_flag = '0'
#   and t.status = '1'
# group by t.plate_formal_guid, t.plate_field_formal_guid, t.plate_field_formal_alias, t.plate_field_norder, t.operation,
#          t.plate_field_content_gc, t.plate_field_value_remark
# order by t.plate_field_norder

select t.plate_guid                                                             as plateGuid
     , t.guid                                                                   as plateFieldGuid
     , case
           when exists(select 1
                       from coz_model_am_aprom_plate_field_content_formal
                       where del_flag = '0'
                         and relate_field_guid = t.guid) and not exists(select 1
                                                                        from coz_category_supplier_am_model_plate
                                                                        where del_flag = '0'
                                                                          and mplate.plate_field_formal_guid = t.guid)
               then '1'
           else '0' end                                                         as relateFlag
     , case
           when (t.source = 2) then t.alias
           else (select name from coz_model_fixed_data where guid = t.name) end as plateFieldName
     , t.alias                                                                  as plateFieldAlias
     , t.norder                                                                 as plateFieldNorder
     , t1.operation                                                             as plateFieldOperation
     , t1.placeholder                                                           as plateFieldPlaceholder
     , t1.file_template                                                         as plateFieldFileTemplate
     , t2.code                                                                  as plateFieldContentCode
     , ifnull(mplate.plate_field_value_remark, uuid())                          as fieldBizGuid
     , CONCAT(
        '{ChildRows_aprcAM\\webSuOrg\\Am\\ModelInfo\\ModePlateValues\\getPlateFieldValuesList_1_0_1:plateFieldGuid=''',
        t.guid, '''}')                                                          as `values`
from coz_model_am_aprom_plate_field_formal t
         inner join coz_model_am_aprom_plate_field_settings_formal t1 on t1.plate_field_guid = t.guid
         left join coz_model_fixed_data t2 on t.content_fixed_data_guid = t2.guid
         left join (select guid, plate_field_formal_guid, plate_field_value_remark
                    from coz_category_supplier_am_model_plate
                    where model_guid = '{modelGuid}'
                      and del_flag = '0'
                      and status = '1') mplate on t.guid = mplate.plate_field_formal_guid
where t.category_guid = @categoryGuid
  and t.del_flag = '0'
  and t1.del_flag = '0'
  and t1.cat_tree_code = 'supply'
group by t.plate_guid, t.guid, t.norder
order by t.norder;

