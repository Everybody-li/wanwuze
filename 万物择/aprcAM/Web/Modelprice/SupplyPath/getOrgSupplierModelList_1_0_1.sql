-- ##Title web后台-审批报价配置管理-xx供应路径-供应审批报价管理-品类审批报价管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询
-- ##Describe 入参”品类类型guid、品类类型名称、品类名称“不参与逻辑计算，原样返回
-- ##Describe t1有数据则返回，t2无数据时，出参型号报价方式为“非二维码”，t2有数据则取t2数据的值
-- ##Describe coz_category_supplier_am_model t1,coz_category_am_modelprice t2
-- ##CallType[QueryData]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid
-- ##input categoryName string[500] NOTNULL;品类名称
-- ##input modelName string[50] NULL;型号名称(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input supplyPathName string[100] NOTNULL;供应路径名称(格式：资金资源需求>管理>债权资金申请)
-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填

-- ##output cattypeGuid char[36] 品类类型guid;
-- ##output cattypeName string[20] 品类类型名称;
-- ##output categoryGuid char[36] 品类guid;
-- ##output categoryName string[500] 品类名称;
-- ##output bizGuid char[36] 业务guid：型号guid;
-- ##output modelName string[50] 型号名称;
-- ##output supplyPathName string[100] 供应路径名称;供应路径名称(格式：资金资源需求>管理>债权资金申请)
-- ##output priceWay enum[0,1] 型号报价方式：1-非二维码，2-二维码;
-- ##output priceWayStr enum[0,1] 型号报价方式：非二维码、二维码;
-- ##output publishBtnHighLightFlag enum[0,1] 发布按钮高亮标志：0-置灰，1-高亮;
-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output qrcode string[42] 二维码图片;二维码图片目录：ARPC/WEB/AM/MODELPRICE/QRCODE/{二维码图片名称guid首字母}/
-- ##outputsupplierGuid char[36] 供方品类表guid;
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统

select
t3.cattype_guid as cattypeGuid
,t3.cattype_name as cattypeName
,t2.category_guid as categoryGuid
,t3.name as categoryName
,t1.guid as bizGuid
,t1.name as modelName
,case when(t4.biz_guid is null) then '1' else t4.price_way end as priceWay
,t4.qrcode
,case when(t4.biz_guid is null) then '非二维码' when(t4.price_way='1') then '非二维码' else '二维码' end as priceWayStr
,case when(t4.publish_flag='0' or t4.publish_flag is null) then '1' else '0' end as publishBtnHighLightFlag
,'{supplyPathName}' as supplyPathName
,left(t4.publish_time,19) as publishTime
,t1.supplier_guid as supplierGuid
,t8.name as orgName
,concat('(+86)',t8.phonenumber) as phonenumber
,(select a.login_sysname from coz_lgcode_fixed_data a where a.guid=t7.lgcode_guid and a.del_flag='0') as supplySystem
from
coz_category_supplier_am_model t1
inner join
coz_category_supplier t2
on t1.supplier_guid=t2.guid
inner join
coz_category_info t3
on t2.category_guid=t3.guid
left join
coz_category_am_modelprice t4
on t1.guid=t4.biz_guid
left join
coz_category_supplydemand t5
on t3.guid=t5.category_guid and t5.del_flag='0'
left join
coz_category_scene_tree t6
on t5.scene_tree_guid=t6.guid and t6.del_flag='0'
left join
coz_cattype_sd_path t7
on t6.sd_path_guid=t7.guid and t7.del_flag='0'
left join
coz_org_info t8
on t2.user_id=t8.user_id
where t1.supplier_guid='{supplierGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t3.cattype_guid='{cattypeGuid}' and t3.name='{categoryName}' and (t1.name like '%{modelName}%' or '{modelName}'='')
order by t1.id desc