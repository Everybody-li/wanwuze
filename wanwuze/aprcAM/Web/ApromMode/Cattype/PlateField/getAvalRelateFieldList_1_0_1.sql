-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-字段名称配置-查询可关联的字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2023-07-31
-- ##Describe 查询未被关联的字段名称列表
-- ##Describe 表名：coz_model_am_aprom_plate_field t1 ,coz_model_am_aprom_plate_field_content t2
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;当前字段名称guid
-- ##input plateGuid char[36] NOTNULL;当前字段名称所属板块guid
-- ##input plateFieldName string[20] NULL;固化字段名称，非必填（模糊搜索）

-- ##output plateFieldGuid char[36] 字段名称guid;字段名称guid
-- ##output plateFieldName string[20] 固化字段名称;固化字段名称

select *
from (
         select t1.guid                                                                   as plateFieldGuid
              , case
                    when (t1.source = 2) then t1.name
                    else (select name from coz_model_fixed_data where guid = t1.name) end as plateFieldName
              , t1.norder
         from coz_model_am_aprom_plate_field t1
         where t1.del_flag = '0'
           and t1.plate_guid = '{plateGuid}' and t1.guid<>'{plateFieldGuid}'
           and not exists(select 1
                          from coz_model_am_aprom_plate_field_content
                          where relate_field_guid = t1.guid
                            and del_flag = '0')
           and t1.category_guid = '{categoryGuid}'
     ) t1
where (t1.plateFieldName like '%{plateFieldName}%' or '{plateFieldName}' = '')
order by t1.norder;
