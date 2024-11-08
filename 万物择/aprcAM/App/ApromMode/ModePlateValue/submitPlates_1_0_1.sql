-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求提交-供方信息-产品信息详情-办理申请提交-非二维码方式
-- ##Author 卢文彪
-- ##CreateTime 2023-08-02
-- ##Describe 保存需方办理申请需求及需求内容：新增t1，t2，入参没有的就放空，
-- ##Describe 将需方需求和选中的供方(入参供方)保存起来，按严格匹配规则类型保存：根据入参supplierGuid 新增t3(t3.request_guid=t1.guid)，t4(t4.request_guid=t1.guid,t4.request_supply_guid=t3.guid)
-- ##Describe 将需方需求和除入参选中的供方以外的其他供方，按系统推荐保存根据入参 t4(t4.request_guid=t1.guid,t4.request_supply_guid=空)，入参没有的就放空，
-- ##Describe 表名：coz_demand_request t1,coz_demand_request_plate t2，coz_demand_request_supply t3,coz_demand_request_match_notice t4,coz_category_supplier t5
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;需求guid，前端自行获取一个
-- ##input plateGuid char[36] NOTNULL;板块名称guid
-- ##input plateAlias string[36] NOTNULL;板块名称别名
-- ##input plateFieldGuid string[36] NOTNULL;字段名称guid
-- ##input plateFieldAlias string[50] NOTNULL;字段名称别名
-- ##input plateFieldValue string[200] NOTNULL;用户填写的字段名称值
-- ##input plateFieldOperation string[1] NOTNULL;字段名称guid
-- ##input plateFieldContentCode string[20] NULL;字段内容固化code，前端根据不同值做不同操作：c00008-行政区域国家/地区。c00009-行政区域省级。c00010-行政区域市级。c00011-行政区域区县级，c00012-行政区域镇级。c00007-日期-年月日。c00017-日期-年月日时分.c00018-日期-年月日时。c00016-产品名称库：从接口[aprc\app\base\catInfo\getCatInfoList_1_0_1]获取字段内容值;
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input plateFieldCode string[20] NULL;板块字段名称固化code，字段来源为系统固化时有值，冗余

insert into coz_demand_request_plate
(
guid
,request_guid
,plate_formal_guid
,plate_formal_alias
,plate_code
,plate_norder
,plate_field_formal_guid
,plate_field_formal_alias
,plate_field_code
,plate_field_norder
,plate_field_content_gc
,plate_field_value
,operation
,status
,del_flag
,create_by
,create_time
)
select
uuid() as guid
,'{requestGuid}' as request_guid
,'{plateGuid}' as plate_formal_guid
,'{plateAlias}' as plate_formal_alias
,'' as plate_code
,'1' as plate_norder
,'{plateFieldGuid}' as plate_field_formal_guid
,'{plateFieldAlias}' as plate_field_formal_alias
,'{plateFieldCode}' as plate_field_code
,'1' as plate_field_norder
,'{plateFieldContentCode}' as plate_field_content_gc
,'{plateFieldValue}' as plate_field_value
,'{plateFieldOperation}' as operation
,'1'
,'0'
,'{curUserId}'
,now()
;
