-- ##Title web后台-审批报价配置管理-品类审批报价管理-发布
-- ##Author 卢文彪
-- ##CreateTime 2023-08-03
-- ##Describe <p style="color:red">前端：发布前先调用接口 aprcAM\Web\Modelprice\isCanPublish_1_0_1 判断是否可以发布，可以再调用该接口：</p>
-- ##Describe 新增或修改
-- ##Describe 如果是第一次发布，则返回提示信息”发布成功“，否则返回提示信息：”发布成功且覆盖原来版本，刷新后可使用“
-- ##Describe 发布逻辑：
-- ##Describe 1、将型号的采购需求信息和供应报价信息块等相关配置草稿表未逻辑删除的的数据复制到对应的正式表，正式表的每个表的guid，都用对应草稿表的guid
-- ##Describe 2、复制后将型号主表t1表的发布状态改为已发布，并新增发布记录t2表
-- ##Describe 表名：coz_category_am_modelprice t1,coz_category_am_modelprice_log t2
-- ##Describe 表名：coz_model_am_modelprice_de_plate t3,coz_model_am_modelprice_de_plate_field t4,coz_model_am_modelprice_de_plate_field_content t5
-- ##Describe 表名：coz_model_am_modelprice_de_plate_formal t6,coz_model_am_modelprice_de_plate_field_formal t7,coz_model_am_modelprice_de_plate_field_content_formal t8
-- ##Describe 表名：coz_model_am_modelprice_sp_plate t9,coz_model_am_modelprice_sp_plate_field t10,coz_model_am_modelprice_sp_plate_field_content t11
-- ##Describe 表名：coz_model_am_modelprice_sp_plate_formal t2,coz_model_am_modelprice_sp_plate_field_formal t13,coz_model_am_modelprice_sp_plate_field_content_formal t14
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;业务guid：型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-发布失败，1-发布成功
-- ##output msg string[100] 操作提示语;操作提示语

set @publishFlag = (select case
                               when exists(select 1
                                           from coz_category_am_modelprice
                                           where biz_guid = '{bizGuid}'
                                             and del_flag = '0'
                                             and publish_flag = '2') then '1'
                               else '0' end)
;
set @existsFlag = (select case
                              when exists(select 1
                                          from coz_category_am_modelprice
                                          where biz_guid = '{bizGuid}'
                                            and del_flag = '0') then '1'
                              else '0' end)
;
set @publishHisFlag = (select case
                                  when exists(select 1
                                              from coz_category_am_modelprice_log
                                              where biz_guid = '{bizGuid}') then '1'
                                  else '0' end)
;

# 删除旧版板块层级关联关系数据
delete
from coz_model_am_clone_guid
where cattype_guid = '{bizGuid}' and @publishFlag = '0';
# 采购需求:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{bizGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_modelprice_de_plate
where biz_guid = '{bizGuid}'
  and del_flag = '0'
  and @publishFlag = '0'
;

# 采购需求:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{bizGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_modelprice_de_plate_field
where biz_guid = '{bizGuid}'
  and del_flag = '0'
  and @publishFlag = '0'
;

# 采购需求:新增板块字段与板块字段内容层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{bizGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_modelprice_de_plate_field_content
where biz_guid = '{bizGuid}'
  and category_guid = cattype_guid
  and del_flag = '0'
  and @publishFlag = '0'
;

# 供应报价:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{bizGuid}', '2', guid, uuid(), create_by, now()
from coz_model_am_modelprice_sp_plate
where biz_guid = '{bizGuid}'
  and del_flag = '0'
  and @publishFlag = '0'
;

# 供应报价:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{bizGuid}', '2', guid, uuid(), create_by, now()
from coz_model_am_modelprice_sp_plate_field
where biz_guid = '{bizGuid}'
  and del_flag = '0'
  and @publishFlag = '0'
;

# 供应报价:新增板块字段与板块字段内容层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{bizGuid}', '2', guid, uuid(), create_by, now()
from coz_model_am_modelprice_sp_plate_field_content
where biz_guid = '{bizGuid}'
  and category_guid = cattype_guid
  and del_flag = '0'
  and @publishFlag = '0'
;



delete
from coz_model_am_modelprice_de_plate_field_content_formal
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_modelprice_de_plate_formal
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_modelprice_de_plate_field_formal
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_modelprice_sp_plate_field_content_formal
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_modelprice_sp_plate_formal
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
;
delete
from coz_model_am_modelprice_sp_plate_field_formal
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
;
insert into coz_category_am_modelprice_log
( guid
, biz_guid
, cattype_guid
, category_guid
, price_way
, qrcode
, qrcode_url
, publish_flag
, publish_time
, publish_by
, del_flag
, create_by
, create_time)
select uuid()
     , '{bizGuid}'
     , category_guid
     , cattype_guid
     , price_way
     , qrcode
     , qrcode_url
     , '2'
     , now()
     , '{curUserId}'
     , '0'
     , '{curUserId}'
     , now()
from coz_category_am_modelprice
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and @existsFlag = '1'
order by id desc
limit 1
;
update coz_category_am_modelprice
set publish_flag='2'
  , publish_time=now()
  , publish_by='{curUserId}'
  , qrcode=''
  , qrcode_url=''
where biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and @existsFlag = '1'
;
insert into coz_category_am_modelprice_log
( guid
, biz_guid
, cattype_guid
, category_guid
, publish_flag
, publish_time
, publish_by
, del_flag
, create_by
, create_time)
select uuid()
     , '{bizGuid}'
     , t1.category_guid
     , t2.cattype_guid
     , '2'
     , now()
     , '{curUserId}'
     , '0'
     , '{curUserId}'
     , now()
from coz_category_supplier_am_model t
         inner join
     coz_category_supplier t1
     on t.supplier_guid = t1.guid
         inner join
     coz_category_info t2
     on t1.category_guid = t2.guid
where t.guid = '{bizGuid}'
  and @publishFlag = '0'
  and @existsFlag = '0'
;
insert into coz_category_am_modelprice
( biz_guid
, cattype_guid
, category_guid
, publish_flag
, publish_time
, publish_by
, del_flag
, create_by
, create_time)
select '{bizGuid}'
     , t1.category_guid
     , t2.cattype_guid
     , '2'
     , now()
     , '{curUserId}'
     , '0'
     , '{curUserId}'
     , now()
from coz_category_supplier_am_model t
         inner join
     coz_category_supplier t1
     on t.supplier_guid = t1.guid
         inner join
     coz_category_info t2
     on t1.category_guid = t2.guid
where t.guid = '{bizGuid}'
  and @publishFlag = '0'
  and @existsFlag = '0'
;
insert into coz_model_am_modelprice_de_plate_formal
( guid
, cattype_guid
, category_guid
, biz_guid
, fixed_data_code
, alias
, norder
, version
, del_flag
, create_by
, create_time
, update_by
, update_time)
select guid
     , cattype_guid
     , category_guid
     , '{bizGuid}'
     , fixed_data_code
     , alias
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_de_plate t
where del_flag = '0'
  and biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate_formal where guid = t.guid)
;
insert into coz_model_am_modelprice_de_plate_field_formal
( guid
, cattype_guid
, category_guid
, biz_guid
, plate_guid
, name
, alias
, source
, operation
, placeholder
, file_template
, norder
, content_source
, content_fixed_data_guid
, version
, del_flag
, create_by
, create_time)
select guid
     , cattype_guid
     , category_guid
     , biz_guid
     , plate_guid
     , name
     , alias
     , source
     , operation
     , placeholder
     , file_template
     , norder
     , content_source
     , content_fixed_data_guid
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_de_plate_field t
where del_flag = '0'
  and biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate_field_formal where guid = t.guid)
;
insert into coz_model_am_modelprice_de_plate_field_content_formal
( guid
, cattype_guid
, category_guid
, biz_guid
, plate_field_guid
, name
, norder
, version
, del_flag
, create_by
, create_time)
select guid
     , cattype_guid
     , category_guid
     , biz_guid
     , plate_field_guid
     , name
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_de_plate_field_content t
where del_flag = '0'
  and biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate_field_content_formal where guid = t.guid)
;
insert into coz_model_am_modelprice_sp_plate_formal
( guid
, cattype_guid
, category_guid
, biz_guid
, fixed_data_code
, alias
, norder
, version
, del_flag
, create_by
, create_time
, update_by
, update_time)
select guid
     , cattype_guid
     , category_guid
     , '{bizGuid}'
     , fixed_data_code
     , alias
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_sp_plate t
where del_flag = '0'
  and biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate_formal where guid = t.guid)
;
insert into coz_model_am_modelprice_sp_plate_field_formal
( guid
, cattype_guid
, category_guid
, biz_guid
, plate_guid
, name
, alias
, source
, operation
, placeholder
, file_template
, norder
, content_source
, content_fixed_data_guid
, version
, del_flag
, create_by
, create_time)
select guid
     , cattype_guid
     , category_guid
     , biz_guid
     , plate_guid
     , name
     , alias
     , source
     , operation
     , placeholder
     , file_template
     , norder
     , content_source
     , content_fixed_data_guid
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_sp_plate_field t
where del_flag = '0'
  and biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate_field_formal where guid = t.guid)
;
insert into coz_model_am_modelprice_sp_plate_field_content_formal
( guid
, cattype_guid
, category_guid
, biz_guid
, plate_field_guid
, name
, norder
, version
, del_flag
, create_by
, create_time)
select guid
     , cattype_guid
     , category_guid
     , biz_guid
     , plate_field_guid
     , name
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_sp_plate_field_content t
where del_flag = '0'
  and biz_guid = '{bizGuid}'
  and @publishFlag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate_field_content_formal where guid = t.guid)
;
select case when (@publishFlag = '0') then '1' else '0' end as okFlag
     , case
           when (@publishFlag = '1') then '已发布，无需操作'
           when (@publishHisFlag = '1') then '发布成功且覆盖原来版本，刷新后可使用'
           else '发布成功' end                              as msg
;










