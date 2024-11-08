-- ##Title web后台-审批报价配置管理-品类审批报价管理-克隆型号-单个克隆
-- ##Author 卢文彪
-- ##CreateTime 2023-12-04
-- ##Describe 新增或修改
-- ##Describe 克隆逻辑：
-- ##Describe 1、将型号的采购需求信息和供应需求信息块等相关配置草稿表未逻辑删除的的数据复制到对应的正式表，正式表的每个表的guid，都用对应草稿表的guid
-- ##Describe 2、复制后将型号主表t1表的发布状态改为已发布，并新增发布记录t2表
-- ##Describe 表名：coz_category_am_modelprice t1,coz_category_am_modelprice_log t2
-- ##Describe 表名：coz_model_am_modelprice_de_plate t3,coz_model_am_modelprice_de_plate_field t4,coz_model_am_modelprice_de_plate_field_content t5
-- ##Describe 表名：coz_model_am_modelprice_de_plate_formal t6,coz_model_am_modelprice_de_plate_field_formal t7,coz_model_am_modelprice_de_plate_field_content_formal t8
-- ##Describe 表名：coz_model_am_modelprice_sp_plate t9,coz_model_am_modelprice_sp_plate_field t10,coz_model_am_modelprice_sp_plate_field_content t11
-- ##Describe 表名：coz_model_am_modelprice_sp_plate_formal t2,coz_model_am_modelprice_sp_plate_field_formal t13,coz_model_am_modelprice_sp_plate_field_content_formal t14
-- ##Describe  <p> style="color:red;font-weight:bold",前端：选中多个型号进行克隆,逐个循环调用该接口,并采用进度条方式实现 </p>
-- ##CallType[QueryData]

-- ##input sourceBizGuid char[36] NOTNULL;业务guid：克隆的源型号guid
-- ##input targetBizGuid char[36] NOTNULL;业务guid：克隆的目标型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-克隆失败，1-克隆成功
-- ##output msg string[100] 操作提示语;操作提示语

# 模板型号是否发布过或模板型号是二维码的,不允许作为克隆模板,型号报价方式：1-非二维码，2-二维码
set @sourcePriceWay = '0';
select price_way
into @sourcePriceWay
from coz_category_am_modelprice_log
where biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
order by id desc
limit 1;

#逻辑删除 采购需求信息和供应需求信息的 草稿表数据
update coz_model_am_modelprice_de_plate
set del_flag   ='2',
    update_time=now(),
    update_by='{curUserId}'
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
update coz_model_am_modelprice_de_plate_field
set del_flag   ='2',
    update_time=now(),
    update_by='{curUserId}'
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;

update coz_model_am_modelprice_de_plate_field_content
set del_flag   ='2',
    update_time=now(),
    update_by='{curUserId}'
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;

update coz_model_am_modelprice_sp_plate
set del_flag   ='2',
    update_time=now(),
    update_by='{curUserId}'
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;

update
    coz_model_am_modelprice_sp_plate_field
set del_flag   ='2',
    update_time=now(),
    update_by='{curUserId}'
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
update
    coz_model_am_modelprice_sp_plate_field_content
set del_flag   ='2',
    update_time=now(),
    update_by='{curUserId}'
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
#物理删除 采购需求信息和供应需求信息的 正式表数据
delete
from coz_model_am_modelprice_de_plate_formal
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
delete
from coz_model_am_modelprice_de_plate_field_formal
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
delete
from coz_model_am_modelprice_de_plate_field_content_formal
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
delete
from coz_model_am_modelprice_sp_plate_formal
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
delete
from coz_model_am_modelprice_sp_plate_field_formal
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;
delete
from coz_model_am_modelprice_sp_plate_field_content_formal
where @sourcePriceWay = '1'
  and biz_guid = '{targetBizGuid}'
;


# 型号guid不存在时新增型号报价为已发布
set @targetExistFlag = 0;
select count(1)
into @targetExistFlag
from coz_category_am_modelprice
where biz_guid = '{targetBizGuid}';

insert into coz_category_am_modelprice (biz_guid, cattype_guid, category_guid, price_way, qrcode, qrcode_url,
                                        publish_flag, publish_time, publish_by, create_by, create_time)
select '{targetBizGuid}',
       cattype_guid,
       category_guid,
       price_way,
       qrcode,
       qrcode_url,
       publish_flag,
       now(),
       '{curUserId}',
       '{curUserId}',
       now()
from coz_category_am_modelprice
where @targetExistFlag = 0
  and biz_guid = '{sourceBizGuid}'
;

# 型号guid已存在时更新型号报价为已发布
update coz_category_am_modelprice
set price_way   = '1'
  , publish_flag='2'
  , publish_time=now()
  , publish_by='{curUserId}'
  , qrcode=''
  , qrcode_url=''
where @sourcePriceWay = '1'
  and @targetExistFlag = 1
  and biz_guid = '{targetBizGuid}'
;

# 新增发布记录表
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
, from_biz_guid
, del_flag
, create_by
, create_time)
select uuid()
     , '{targetBizGuid}'
     , category_guid
     , cattype_guid
     , price_way
     , qrcode
     , qrcode_url
     , '2'
     , now()
     , '{curUserId}'
     , '{sourceBizGuid}'
     , '0'
     , '{curUserId}'
     , now()
from coz_category_am_modelprice_log
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
order by id desc
limit 1
;
# 更新模板板块层级关联关系
# update coz_model_am_clone_guid
# set new_t_guid = uuid()
# where cattype_guid = '{sourceBizGuid}';

# 删除旧版板块层级关联关系数据
delete
from coz_model_am_clone_guid
where @sourcePriceWay = '1'
  and cattype_guid = '{sourceBizGuid}';
# 采购需求:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{sourceBizGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_modelprice_de_plate
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
;

# 采购需求:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{sourceBizGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_modelprice_de_plate_field
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
;

# 采购需求:新增板块字段与板块字段内容层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{sourceBizGuid}', '1', guid, uuid(), create_by, now()
from coz_model_am_modelprice_de_plate_field_content
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
;

# 供应报价:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{sourceBizGuid}', '2', guid, uuid(), create_by, now()
from coz_model_am_modelprice_sp_plate
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
;

# 供应报价:新增板块与板块字段层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{sourceBizGuid}', '2', guid, uuid(), create_by, now()
from coz_model_am_modelprice_sp_plate_field
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
;

# 供应报价:新增板块字段与板块字段内容层级关联关系
insert into coz_model_am_clone_guid (guid, cattype_guid, biz_type, old_t_guid, new_t_guid, create_by,
                                     create_time)
select uuid(), '{sourceBizGuid}', '2', guid, uuid(), create_by, now()
from coz_model_am_modelprice_sp_plate_field_content
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
;


# 新增 采购需求信息和供应需求信息的 草稿表数据
insert into coz_model_am_modelprice_de_plate
( guid
, cattype_guid
, category_guid
, biz_guid
, fixed_data_code
, alias
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select acg.new_t_guid
     , t.cattype_guid
     , t.category_guid
     , '{targetBizGuid}'
     , fixed_data_code
     , alias
     , norder
     , del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_de_plate t
         inner join coz_model_am_clone_guid acg on t.guid = acg.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate where guid = acg.new_t_guid)
;
insert into coz_model_am_modelprice_de_plate_field
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
, del_flag
, create_by
, create_time)
select acgField.new_t_guid
     , t.cattype_guid
     , t.category_guid
     , '{targetBizGuid}'
     , acgPlate.new_t_guid
     , name
     , alias
     , source
     , operation
     , placeholder
     , file_template
     , norder
     , content_source
     , content_fixed_data_guid
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_de_plate_field t
         inner join coz_model_am_clone_guid acgField on t.guid = acgField.old_t_guid
         inner join coz_model_am_clone_guid acgPlate on t.plate_guid = acgPlate.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate_field where guid = acgField.new_t_guid)
;
insert into coz_model_am_modelprice_de_plate_field_content
( guid
, cattype_guid
, category_guid
, biz_guid
, plate_field_guid
, name
, norder
, del_flag
, create_by
, create_time)
select acgFieldContent.new_t_guid
     , t.cattype_guid
     , category_guid
     , '{targetBizGuid}'
     , acgField.new_t_guid
     , name
     , norder
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_de_plate_field_content t
         inner join coz_model_am_clone_guid acgFieldContent on t.guid = acgFieldContent.old_t_guid
         inner join coz_model_am_clone_guid acgField on t.plate_field_guid = acgField.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate_field_content where guid = acgFieldContent.new_t_guid)
;
insert into coz_model_am_modelprice_sp_plate
( guid
, cattype_guid
, category_guid
, biz_guid
, fixed_data_code
, alias
, norder
, del_flag
, create_by
, create_time
, update_by
, update_time)
select acg.new_t_guid
     , t.cattype_guid
     , t.category_guid
     , '{targetBizGuid}'
     , fixed_data_code
     , alias
     , norder
     , del_flag
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_sp_plate t
         inner join coz_model_am_clone_guid acg on t.guid = acg.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate where guid = acg.new_t_guid)
;
insert into coz_model_am_modelprice_sp_plate_field
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
, del_flag
, create_by
, create_time)
select acgField.new_t_guid
     , t.cattype_guid
     , category_guid
     , '{targetBizGuid}'
     , acgPlate.new_t_guid
     , name
     , alias
     , source
     , operation
     , placeholder
     , file_template
     , norder
     , content_source
     , content_fixed_data_guid
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_sp_plate_field t
         inner join coz_model_am_clone_guid acgField on t.guid = acgField.old_t_guid
         inner join coz_model_am_clone_guid acgPlate on t.plate_guid = acgPlate.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate_field where guid = acgField.new_t_guid)
;
insert into coz_model_am_modelprice_sp_plate_field_content
( guid
, cattype_guid
, category_guid
, biz_guid
, plate_field_guid
, name
, norder
, del_flag
, create_by
, create_time)
select acgFieldContent.new_t_guid
     , t.cattype_guid
     , t.category_guid
     , '{targetBizGuid}'
     , acgField.new_t_guid
     , name
     , norder
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_sp_plate_field_content t
         inner join coz_model_am_clone_guid acgFieldContent on t.guid = acgFieldContent.old_t_guid
         inner join coz_model_am_clone_guid acgField on t.plate_field_guid = acgField.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate_field_content where guid = acgFieldContent.new_t_guid)
;

# 新增 采购需求信息和供应需求信息的 正式表数据
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
select acg.new_t_guid
     , t.cattype_guid
     , category_guid
     , '{targetBizGuid}'
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
         inner join coz_model_am_clone_guid acg on t.guid = acg.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate_formal where guid = acg.new_t_guid)
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
select acgField.new_t_guid
     , t.cattype_guid
     , t.category_guid
     , '{targetBizGuid}'
     , acgPlate.new_t_guid
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
         inner join coz_model_am_clone_guid acgField on t.guid = acgField.old_t_guid
         inner join coz_model_am_clone_guid acgPlate on t.plate_guid = acgPlate.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_de_plate_field_formal where guid = acgField.new_t_guid)
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
select acgFieldContent.new_t_guid
     , t.cattype_guid
     , category_guid
     , '{targetBizGuid}'
     , acgField.new_t_guid
     , name
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_de_plate_field_content t
         inner join coz_model_am_clone_guid acgFieldContent on t.guid = acgFieldContent.old_t_guid
         inner join coz_model_am_clone_guid acgField on t.plate_field_guid = acgField.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1
                 from coz_model_am_modelprice_de_plate_field_content_formal
                 where guid = acgFieldContent.new_t_guid)
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
select acg.new_t_guid
     , t.cattype_guid
     , category_guid
     , '{targetBizGuid}'
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
         inner join coz_model_am_clone_guid acg on t.guid = acg.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate_formal where guid = acg.new_t_guid)
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
select acgField.new_t_guid
     , t.cattype_guid
     , category_guid
     , '{targetBizGuid}'
     , acgPlate.new_t_guid
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
         inner join coz_model_am_clone_guid acgField on t.guid = acgField.old_t_guid
         inner join coz_model_am_clone_guid acgPlate on t.plate_guid = acgPlate.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1 from coz_model_am_modelprice_sp_plate_field_formal where guid = acgField.new_t_guid)
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
select acgFieldContent.new_t_guid
     , t.cattype_guid
     , category_guid
     , '{targetBizGuid}'
     , acgField.new_t_guid
     , name
     , norder
     , 1
     , del_flag
     , '{curUserId}'
     , now()
from coz_model_am_modelprice_sp_plate_field_content t
         inner join coz_model_am_clone_guid acgFieldContent on t.guid = acgFieldContent.old_t_guid
         inner join coz_model_am_clone_guid acgField on t.plate_field_guid = acgField.old_t_guid
where @sourcePriceWay = '1'
  and biz_guid = '{sourceBizGuid}'
  and del_flag = '0'
  and not exists(select 1
                 from coz_model_am_modelprice_sp_plate_field_content_formal
                 where guid = acgFieldContent.new_t_guid)
;

# 返回查询结果
select case when (@sourcePriceWay = '1') then '1' else '0' end as okFlag
     , case
           when (@sourcePriceWay = '2') then '模板型号是二维码或模板型号未发布过，无需克隆,请重新选择模板型号'
           else '克隆成功' end                                 as msg
;


