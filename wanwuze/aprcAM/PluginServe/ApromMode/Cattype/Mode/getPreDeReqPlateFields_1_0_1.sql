-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-查询提交的渠道需求内容详情-板块字段列表
-- ##Author lith
-- ##CreateTime 2023-12-04
-- ##Describe 表名：coz_aprom_pre_demand_request,coz_aprom_pre_demand_request_plate
-- ##CallType[QueryData]

-- ##input preRequestGuid char[36] NOTNULL;渠道需求guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

select t.plate_formal_guid                      as plateGuid
     , t.plate_field_formal_guid                as plateFieldGuid
     , t.plate_field_formal_alias               as plateFieldAlias
     , t.plate_field_norder                     as plateFieldNorder
     , t.operation                              as plateFieldOperation
     , t.plate_field_code                       as plateFieldCode
     , t.plate_field_content_gc                 as plateFieldContentCode
     , pfsf.placeholder                         as plateFieldPlaceholder
     , pfsf.file_template                       as plateFieldFileTemplate
     , case
           when exists(select 1
                       from coz_model_am_aprom_plate_field_content_formal
                       where del_flag = '0'
                         and relate_field_guid = t.plate_field_formal_guid) then '1'
           else '0' end                         as relateFlag
     , CONCAT('{ChildRows_aprcAM\\App\\ApromMode\\ModePlateValue\\getPreDeReqPlateFieldValues_1_0_1:plateFieldGuid=''',
              t.plate_field_formal_guid, '''}') as `values`
from coz_aprom_pre_demand_request_plate t
         inner join coz_model_am_aprom_plate_field_settings_formal pfsf
                    on t.plate_field_formal_guid = pfsf.plate_field_guid and pfsf.cat_tree_code = 'demand'
where t.request_guid = '{preRequestGuid}'
  and t.del_flag = '0'
  and t.status = '1';
