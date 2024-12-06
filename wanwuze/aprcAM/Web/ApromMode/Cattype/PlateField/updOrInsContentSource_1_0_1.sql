-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购/供应需求信息配置-字段名称配置-字段内容配置-内容来源设置
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 新增或修改，设置字段名称的字段内容来源，入参plateFieldGuid和入参catTreeCode的组合存在时修改，不存在时新增
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field_settings t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input catTreeCode enum[demand,supply] NOTNULL;供需区分：demand-采购需求，supply-供应需求
-- ##input contentSource enum[1,2,3,4] NOTNULL;字段内容来源：1-字段内容固化库，2-字段内容自建库，3-操作用户方(需方或供方)
-- ##input curUserId char[36] NOTNULL;当前登录用户id


set @flag1=(select case when exists(select 1 from coz_model_am_aprom_plate_field_settings where plate_field_guid='{plateFieldGuid}' and cat_tree_code='{catTreeCode}' and del_flag='0') then '1' else '0' end)
;
update coz_model_am_aprom_plate_field_settings
set content_source='{contentSource}'
,operation='0'
,cat_tree_code='{catTreeCode}'
,update_by='{curUserId}'
,update_time=now()
where plate_field_guid='{plateFieldGuid}' and cat_tree_code='{catTreeCode}' and @flag1='1'
;
update coz_model_am_aprom_plate_field
set 
-- content_fixed_data_guid=case when ('{contentSource}'='2') then '' else content_fixed_data_guid end
-- ,source=case when ('{contentSource}'='1') then '1' when ('{contentSource}'='2') then '2' else source end
content_fixed_data_guid=''
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}'
;
update coz_model_am_aprom_plate_field_content
set del_flag='2'
where plate_field_guid='{plateFieldGuid}' and '{contentSource}'='1'
;
update coz_model_am_aprom_plate_field_settings
set content_source='3'
,operation='2'
,cat_tree_code='supply'
,update_by='{curUserId}'
,update_time=now()
where plate_field_guid='{plateFieldGuid}' and cat_tree_code='supply' and @flag1='1' and '{catTreeCode}'='demand' and ('{contentSource}'='1' or '{contentSource}'='2')
;
insert into coz_model_am_aprom_plate_field_settings
(
guid
,cattype_guid
,category_guid
,plate_field_guid
,cat_tree_code
,content_source
,operation
,norder
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
UUID() as guid
,'{categoryGuid}' as cattype_guid
,'{categoryGuid}' as category_guid
,'{plateFieldGuid}' as plateFieldGuid
,'{catTreeCode}' as cat_tree_code
,'{contentSource}' as contentSource
,'0' as operation
,ifnull((select (max(norder)+1) from coz_model_am_aprom_plate_field_settings where plate_field_guid='{plateFieldGuid}' and del_flag='0' and category_guid='{categoryGuid}'),1) as norder
,0 as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now()as update_time
where 
@flag1='0'
;
insert into coz_model_am_aprom_plate_field_settings
(
guid
,cattype_guid
,category_guid
,plate_field_guid
,cat_tree_code
,content_source
,operation
,norder
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
UUID() as guid
,'{categoryGuid}' as cattype_guid
,'{categoryGuid}' as category_guid
,'{plateFieldGuid}' as plateFieldGuid
,'supply' as cat_tree_code
,'3' as contentSource
,'2' as operation
,ifnull((select (max(norder)+1) from coz_model_am_aprom_plate_field_settings where plate_field_guid='{plateFieldGuid}' and del_flag='0' and category_guid='{categoryGuid}'),1) as norder
,0 as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now()as update_time
where 
@flag1='0' and '{catTreeCode}'='demand' and ('{contentSource}'='1' or '{contentSource}'='2')
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}
