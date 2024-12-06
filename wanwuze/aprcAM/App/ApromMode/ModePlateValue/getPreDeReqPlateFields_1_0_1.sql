-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-查询提交的渠道需求内容详情-板块字段列表
-- ##Author lith
-- ##CreateTime 2023-12-04
-- ##Describe 表名：coz_aprom_pre_demand_request,coz_aprom_pre_demand_request_plate
-- ##CallType[QueryData]

-- ##input preRequestGuid char[36] NOTNULL;渠道需求guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

select pff.plate_guid          as plateGuid
     , pff.guid                as plateFieldGuid
     , pff.alias               as plateFieldAlias
     , pff.norder              as plateFieldNorder
     , pfsf.operation          as plateFieldOperation
     , fieldFd.code            as plateFieldCode
     , fieldContentfd.code     as plateFieldContentCode
     , pfsf.placeholder        as plateFieldPlaceholder
     , pfsf.placeholder        as plateFieldPlaceholder
     , pfsf.file_template      as plateFieldFileTemplate
     , case
           when exists(select 1
                       from coz_model_am_aprom_plate_field_content_formal
                       where del_flag = '0'
                         and relate_field_guid = pff.guid)
               and not exists(select 1
                              from coz_aprom_pre_demand_request_plate
                              where request_guid = '{preRequestGuid}'
                                and del_flag = '0'
                                and plate_field_relate_field_guid = pff.guid) then '1'
           else '0' end        as relateFlag
     , CONCAT('{ChildRows_aprcAM\\App\\ApromMode\\ModePlateValue\\getPreDeReqPlateFieldValues_1_0_1:plateFieldGuid=''',
              pff.guid, '''}') as `values`
from coz_model_am_aprom_plate_field_formal pff
         left join coz_model_fixed_data fieldFd on pff.name = fieldFd.guid
         left join coz_model_fixed_data fieldContentfd on pff.content_fixed_data_guid = fieldContentfd.guid
         inner join coz_aprom_pre_demand_request pdr on pff.category_guid = pdr.category_guid
         inner join coz_model_am_aprom_plate_field_settings_formal pfsf
                    on pff.guid = pfsf.plate_field_guid and pfsf.cat_tree_code = 'demand'
where pdr.guid = '{preRequestGuid}'
  and pdr.del_flag = '0'
  and pff.del_flag = '0'
  and pdr.status = '1'
order by pff.norder;
