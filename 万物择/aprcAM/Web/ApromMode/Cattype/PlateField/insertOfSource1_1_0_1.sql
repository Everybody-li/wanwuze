-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-字段名称配置-添加库字段名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 新增t1，操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;当前登录用户id
-- ##input fixedDataCodeGuid char[36] NOTNULL;库字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

insert into coz_model_am_aprom_plate_field
(
guid
,cattype_guid
,category_guid
,plate_guid
,name
,alias
,source
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
,'' as plateGuid
,'{fixedDataCodeGuid}' as name
,(select name from coz_model_fixed_data where guid='{fixedDataCodeGuid}' and del_flag='0') as alias
,'1' as source
,ifnull((select (max(norder)+1) from coz_model_am_aprom_plate_field where del_flag='0' and category_guid='{categoryGuid}'),1) as norder
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' update_by
,now()as update_time
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}

