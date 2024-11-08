-- ##Title 插件端-web后台-审批模式-通用配置-供需需求信息管理-发布逻辑-修改渠道需求内容为失效
-- ##Author 卢文彪
-- ##CreateTime 2023-12-05
-- ##Describe 查询： 修改生效标志为失效
-- ##Describe 表名：coz_aprom_pre_demand_request_plate
-- ##CallType[ExSql]

-- ##input preRequestGuid char[36] NOTNULL;渠道需求guid
-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_aprom_pre_demand_request
set status='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{preRequestGuid}'
;
update coz_aprom_pre_demand_request_plate
set status='0'
where request_guid='{preRequestGuid}'
;
