-- ##Title 插件端-web后台-审批模式-通用配置/配置管理-供需需求信息管理-克隆品类(克隆发布)
-- ##Author 卢文彪
-- ##CreateTime 2023-07-28
-- ##Describe <p style="color:red">前端：
-- ##Describe 1、查询采购路径、查询需求场景选择、查询品类名称列表 同交易模式的功能，接口不变
-- ##Describe 2、克隆动产调用的发布接口更换成：多选，循环调用当前接口进行发布，百分比前端自行统计，展示格式：N/N (已发布的数量/多选选中的总数量)</p>
-- ##Describe 后端： 新增,将入参品类类型的正式表的数据数据复制一份给入参品类名称(草稿表和正式表)
-- ##Describe 前置条件：入参品类类型guid在t2中有数据(入参cattypeGuid = t2.category_guid)，则可以克隆，否则返回操作失败，提示语：当前品类类型没有发布过，不允许克隆
-- ##Describe
-- ##Describe 克隆逻辑：
-- ##Describe 1、从正式表获取品类类型的数据(t7,t8,t9,t10：这些表的品类guid=入参品类类型guid)
-- ##Describe 2、将步骤1的数据复制给品类名称的草稿表(t3,t4,t5,t6)，各表的guid都新生成，品类名称的t1表状态改为已发布，t2新增一条发布记录数据
-- ##Describe 3、将步骤2的数据复制给品类名称的正式表(t7,t8,t9,t10)，连同表的guid一起复制
-- ##Describe 表名：coz_model_am_aprom_mode t1,coz_model_am_aprom_mode_log t2
-- ##Describe 表名：coz_model_am_aprom_plate t3,coz_model_am_aprom_plate_field t4,coz_model_am_aprom_plate_field_settings t5, coz_model_am_aprom_plate_field_content t6,
-- ##Describe 表名：coz_model_am_aprom_plate_formal t7,coz_model_am_aprom_plate_field_formal t8,coz_model_am_aprom_plate_field_settings_formal t9，coz_model_am_aprom_plate_field_content_formal t10
-- ##CallType[QueryData]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid
-- ##input categoryGuid char[36] NOTNULL;品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-失败，1-成功
-- ##output msg string[100] 操作提示语;操作提示语


set @publishFlag = (select case
                               when exists(select 1
                                           from coz_category_am_aprom_mode_log
                                           where cattype_guid = '{cattypeGuid}') then '1'
                               else '0' end)
;
update coz_model_am_clone_guid
set new_t_guid=uuid()
where cattype_guid = '{cattypeGuid}'
  and biz_type = '1'
  and @publishFlag = '1'
;

delete
from coz_model_am_aprom_plate_field_content
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
delete
from coz_model_am_aprom_plate
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
delete
from coz_model_am_aprom_plate_field
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
delete
from coz_model_am_aprom_plate_field_settings
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;

delete
from coz_model_am_aprom_plate_field_content_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
delete
from coz_model_am_aprom_plate_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
delete
from coz_model_am_aprom_plate_field_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
delete
from coz_model_am_aprom_plate_field_settings_formal
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
insert into coz_category_am_aprom_mode_log
    (guid, category_guid, cattype_guid, create_by, create_time)
select uuid(),
       category_guid,
       cattype_guid,
       '{curUserId}',
       create_time
from coz_category_am_aprom_mode
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
order by id desc
limit 1
;
update coz_category_am_aprom_mode
set publish_flag='2'
  , publish_time=now()
  , publish_by='{curUserId}'
where category_guid = '{categoryGuid}'
  and @publishFlag = '1'
;
insert into coz_model_am_aprom_plate
( guid
, cattype_guid
, category_guid
, fixed_data_code
, alias
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t1.fixed_data_code
     , t1.alias
     , t1.norder
     , del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_formal t1
         inner join
     coz_model_am_clone_guid t2
     on t1.guid = t2.old_t_guid
where t1.del_flag = '0'
  and t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate where guid = t2.new_t_guid)
;
insert into coz_model_am_aprom_plate_formal
( guid
, cattype_guid
, category_guid
, fixed_data_code
, alias
, norder
, version
, del_flag
, create_by
, create_time
, update_by
, update_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t1.fixed_data_code
     , t1.alias
     , t1.norder
     , '1'
     , t1.del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_formal t1
         inner join
     coz_model_am_clone_guid t2
     on t1.guid = t2.old_t_guid
where t1.del_flag = '0'
  and t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate_formal where guid = t2.new_t_guid)
;
insert into coz_model_am_aprom_plate_field
( guid
, cattype_guid
, category_guid
, plate_guid
, name
, alias
, source
, content_fixed_data_guid
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t3.new_t_guid
     , t1.name
     , t1.alias
     , t1.source
     , t1.content_fixed_data_guid
     , t1.norder
     , t1.del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_formal t1
         inner join coz_model_am_clone_guid t2 on t1.guid = t2.old_t_guid
         inner join coz_model_am_clone_guid t3 on t1.plate_guid = t3.old_t_guid
where t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and t1.del_flag = '0'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate_field where guid = t2.new_t_guid)
;
insert into coz_model_am_aprom_plate_field_formal
( guid
, cattype_guid
, category_guid
, plate_guid
, name
, alias
, source
, content_fixed_data_guid
, norder
, version
, del_flag
, create_by
, create_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t3.new_t_guid
     , t1.name
     , t1.alias
     , t1.source
     , t1.content_fixed_data_guid
     , t1.norder
     , 1
     , t1.del_flag
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_formal t1
         inner join coz_model_am_clone_guid t2 on t1.guid = t2.old_t_guid
         inner join coz_model_am_clone_guid t3 on t1.plate_guid = t3.old_t_guid
where t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and t1.del_flag = '0'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate_field_formal where guid = t2.new_t_guid)
;
insert into coz_model_am_aprom_plate_field_content
( guid
, cattype_guid
, category_guid
, plate_field_guid
, name
, relate_field_guid
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t3.new_t_guid
     , t1.name
     , ifnull(t4.new_t_guid, '')
     , t1.norder
     , t1.del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_content_formal t1
         inner join coz_model_am_clone_guid t2 on t1.guid = t2.old_t_guid
         inner join coz_model_am_clone_guid t3 on t1.plate_field_guid = t3.old_t_guid
         left join coz_model_am_clone_guid t4 on t1.relate_field_guid = t4.old_t_guid
where t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and t1.del_flag = '0'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate_field_content where guid = t2.new_t_guid)
;
insert into coz_model_am_aprom_plate_field_content_formal
( guid
, cattype_guid
, category_guid
, plate_field_guid
, name
, relate_field_guid
, norder
, version
, del_flag
, create_by
, create_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t3.new_t_guid
     , t1.name
     , ifnull(t4.new_t_guid, '')
     , t1.norder
     , 1
     , t1.del_flag
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_content_formal t1
         inner join coz_model_am_clone_guid t2 on t1.guid = t2.old_t_guid
         inner join coz_model_am_clone_guid t3 on t1.plate_field_guid = t3.old_t_guid
         left join coz_model_am_clone_guid t4 on t1.relate_field_guid = t4.old_t_guid
where t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and t1.del_flag = '0'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate_field_content_formal where guid = t2.new_t_guid)
;
insert into coz_model_am_aprom_plate_field_settings
( guid
, cattype_guid
, category_guid
, plate_field_guid
, cat_tree_code
, content_source
, operation
, placeholder
, file_template
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t3.new_t_guid
     , t1.cat_tree_code
     , t1.content_source
     , t1.operation
     , t1.placeholder
     , t1.file_template
     , t1.norder
     , t1.del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_settings_formal t1
         inner join coz_model_am_clone_guid t2 on t1.guid = t2.old_t_guid
         inner join coz_model_am_clone_guid t3 on t1.plate_field_guid = t3.old_t_guid
where t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and t1.del_flag = '0'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate_field_settings where guid = t2.new_t_guid)
;
insert into coz_model_am_aprom_plate_field_settings_formal
( guid
, cattype_guid
, category_guid
, plate_field_guid
, cat_tree_code
, content_source
, operation
, placeholder
, file_template
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select t2.new_t_guid
     , t1.cattype_guid
     , '{categoryGuid}'
     , t3.new_t_guid
     , t1.cat_tree_code
     , t1.content_source
     , t1.operation
     , t1.placeholder
     , t1.file_template
     , t1.norder
     , t1.del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_aprom_plate_field_settings_formal t1
         inner join coz_model_am_clone_guid t2 on t1.guid = t2.old_t_guid
         inner join coz_model_am_clone_guid t3 on t1.plate_field_guid = t3.old_t_guid
where t1.category_guid = '{cattypeGuid}'
  and t2.cattype_guid = '{cattypeGuid}'
  and t2.biz_type = '1'
  and t1.del_flag = '0'
  and @publishFlag = '1'
  and not exists(select 1 from coz_model_am_aprom_plate_field_settings_formal where guid = t2.new_t_guid)
;
select case when (@publishFlag = '1') then '1' else '0' end                    as okFlag
     , case when (@publishFlag = '0') then '当前品类类型没有发布过，不允许克隆' else '发布成功' end as msg
;







