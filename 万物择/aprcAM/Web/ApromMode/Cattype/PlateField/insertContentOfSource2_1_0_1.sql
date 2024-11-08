-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购/供应需求信息配置-字段名称配置-字段内容配置-字段内容管理-新建字段内容
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 新增，相同字段名称下字段内容不重复
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field_content t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input name string[50] NOTNULL;字段内容，前端要去掉前后空格
-- ##input curUserId char[36] NOTNULL;当前登录用户id

insert into coz_model_am_aprom_plate_field_content
(
guid
,cattype_guid
,category_guid
,plate_field_guid
,name
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
,'{name}' as name
,ifnull((select (max(norder)+1) from coz_model_am_aprom_plate_field_content where del_flag='0' and plate_field_guid='{plateFieldGuid}'),1) as norder
,'0' as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now()as update_time
where
not exists(select 1 from coz_model_am_aprom_plate_field_content where del_flag='0' and plate_field_guid='{plateFieldGuid}' and name='{name}' )
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}

