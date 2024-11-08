-- ##Title web后台-审批模式-通用配置-供需需求信息管理-信息格式排序-采购/供应需求信息-修改字段名称排序
-- ##Author 卢文彪
-- ##CreateTime 2023-07-26
-- ##Describe 修改顺序，修改顺序逻辑是插队，不是对换位置
-- ##Describe 操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate_field
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input oldNOrder int[>0] NOTNULL;旧的顺序
-- ##input newNOrder int[>0] NOTNULL;新的顺序
-- ##input curUserId char[36] NOTNULL;当前登录用户id

set @flag1=case when((select norder from coz_model_am_aprom_plate_field where guid='{plateFieldGuid}')={oldNOrder}) then 1 else 0 end
;
set @norderflag=({newNOrder}-{oldNOrder})
;

update coz_model_am_aprom_plate_field
set norder=norder-1
,update_by='{curUserId}'
,update_time=now()
where norder<={newNOrder} and norder>={oldNOrder} and category_guid='{categoryGuid}' and @norderflag>=0 and guid<>'{plateFieldGuid}' and @flag1=1 and del_flag='0'
;
update coz_model_am_aprom_plate_field
set norder=norder+1
,update_by='{curUserId}'
,update_time=now()
where norder>={newNOrder} and norder<={oldNOrder} and category_guid='{categoryGuid}' and @norderflag<=0 and guid<>'{plateFieldGuid}' and @flag1=1 and del_flag='0'
;
update coz_model_am_aprom_plate_field
set norder={newNOrder}
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}' and @flag1=1 and del_flag='0'
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}