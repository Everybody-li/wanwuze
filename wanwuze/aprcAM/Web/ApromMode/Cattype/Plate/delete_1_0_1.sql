-- ##Title web后台-审批模式-通用配置-供需需求信息管理-采购需求信息配置-板块配置-删除板块
-- ##Author 卢文彪
-- ##CreateTime 2023-07-25
-- ##Describe 新增t1，操作后每次都调用接口改主表发布状态：aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1
-- ##Describe 表名：coz_model_am_aprom_plate t1
-- ##CallType[ExSql]

-- ##input categoryGuid char[36] NOTNULL;品类类型guid/品类guid
-- ##input plateGuid char[36] NOTNULL;板块guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_model_am_aprom_plate
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateGuid}'
;


{file[aprcAM\Web\ApromMode\Cattype\Mode\updPublishFlag2UnPub_1_0_1.sql]/file}

