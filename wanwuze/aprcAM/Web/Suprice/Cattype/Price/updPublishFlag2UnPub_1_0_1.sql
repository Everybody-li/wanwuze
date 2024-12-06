-- 目录：aprcAM\Web\Suprice\Cattype\Price\updPublishFlag2UnPub_1_0_1
-- ##Title web后台-审批模式-通用配置/配置管理-供应报价信息管理-将发布标志改为未发布
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 修改t1的发布标志为未发布，仅t1的发布标志是已发布的时候才修改
-- ##Describe coz_category_am_suprice t1
-- ##CallType[ExSql]

-- ##input bizType enum[1,2,3] NOTNULL;业务菜单类型：1-审批模式下的通用或非通用的供应报价信息管理，2-审批报价的采购需求信息配置，3-审批报价的供应报价信息配置
-- ##input bizGuid char[36] NOTNULL;品类型号guid或品类类型guid/品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\Suprice\Cattype\Price\getMainTableNameByBizType_1_0_1&bizType={bizType}&DBC=w_a]/url}
set publish_flag='0'
where biz_guid='{bizGuid}'
;
