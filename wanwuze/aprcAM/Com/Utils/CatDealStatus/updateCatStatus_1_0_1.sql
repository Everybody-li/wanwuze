-- ##Title app-审批模式下的品类-需方-品类交易状态埋点-办理申请点击(点击一次,调用一次)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 修改品类流转状态值
-- ##Describe 适用状态-交易模式:212-供方供应报价，213-需方删除需求，214-需求采购支付，215-供应取消订单，216-需方取消订单，217-供方供应完成，218-需方申请退货，219-订单交易仲裁，220-订单验收通过，221-退款退货订单。审批模式：
-- ##Describe 适用状态-审批模式:313-办理申请提交，314-需方删除申请，315-供应拒绝报价，316-供方供应报价，317-需求采购支付，318-应取消订单，319-供方办理通知，320-供方供应完成，321-退款退货订单，322-订单验收通过
-- ##Describe 逻辑:根据业务guid修改品类交易状态
-- ##Describe 供需双方对接专员信息更新,每次都获取最新绑定的
-- ##Describe 表名： coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_detail t2,coz_server3_sys_user_dj_bind t3
-- ##CallType[ExSql]

-- ##input catDealStatus int[>0] NOTNULL;品类交易状态枚举值
-- ##input bizGuid char[36] NOTNULL;品类交易状态对应的业务guid:需求guid,供应报价guid,订单guid,订单取消guid,订单退货guid,订单仲裁guid
-- ##input supplyUserId char[36] NULL;供方用户id
-- ##input supplyUserName char[36] NULL;供方用户名称(供应机构名称/供应渠道),仅214,317状态下有值
-- ##input supplyUserPhone char[36] NULL;供方用户手机号
-- ##input curUserId char[36] NOTNULL;当前登录用户id

update coz_server3_cate_dealstatus_statistic
set dstatus = {catDealStatus}
,demand_sys_user_guid='{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\DjUser\getDemandWorkUser_1_0_1&bizGuid={bizGuid}&DBC=w_a]/url}'
,supply_sys_user_guid='{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\DjUser\getSupplyWorkUser_1_0_1&bizGuid={bizGuid}&DBC=w_a]/url}'
,supply_user_id='{supplyUserId}'
,supply_user_name='{supplyUserName}'
,supply_user_phone='{supplyUserPhone}'
,update_time=now()
where biz_guid = '{bizGuid}';