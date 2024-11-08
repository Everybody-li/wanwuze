-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-板块配置-添加板块
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 新增t1，操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid
-- ##input fixedDataCode char[36] NOTNULL;固化板块code的guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

insert into coz_model_am_aprom_plate 
(
guid
,cattype_guid
,category_guid
,fixed_data_code
,alias
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
,'{fixedDataCode}' as fixedDataCode
,(select name from coz_model_fixed_data where guid='{fixedDataCode}' and del_flag='0') as alias
,ifnull((select (max(norder)+1) from coz_model_am_aprom_plate where  del_flag='0' and category_guid='{categoryGuid}'),1) as norder
,'0' as del_flag
,'-1' ascreate_by
,now() as create_time
,'-1' as update_by
,now()as update_time
;
{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}

