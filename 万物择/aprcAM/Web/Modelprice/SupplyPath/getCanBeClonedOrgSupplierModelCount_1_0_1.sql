-- ##Title web后台-审批报价配置管理-xx供应路径-供应审批报价管理-品类审批报价管理-查询可克隆的型号列表数量
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询
-- ##Describe 入参”品类类型guid、品类类型名称、品类名称“不参与逻辑计算，原样返回
-- ##Describe t1有数据则返回，t2无数据时，出参型号报价方式为“非二维码”，t2有数据则取t2数据的值
-- ##Describe coz_category_supplier_am_model t1,coz_category_am_modelprice t2
-- ##CallType[QueryData]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid
-- ##input categoryGuid char[36] NOTNULL;品类名称guid
-- ##input sourceBizGuid char[36] NOTNULL;业务guid：克隆的源型号guid
-- ##input modelName string[50] NULL;型号名称(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input supplyPathName string[100] NOTNULL;供应路径名称(格式：资金资源需求>管理>债权资金申请)
-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填

-- ##output CanBeClonedOrgSupplierModelCount int[>0] NOTNULL;可克隆的型号列表数量


select count(1) as CanBeClonedOrgSupplierModelCount
from coz_category_supplier_am_model t1
         inner join
     coz_category_supplier t2
     on t1.supplier_guid = t2.guid
         inner join
     coz_category_info t3
     on t2.category_guid = t3.guid
         left join
     coz_category_am_modelprice t4
     on t1.guid = t4.biz_guid
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
where t1.guid <> '{sourceBizGuid}'
  and t2.category_guid = '{categoryGuid}'
  and t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
  and t3.cattype_guid = '{cattypeGuid}'
--  and t3.name = '{categoryName}'
  and (t1.name like '%{modelName}%' or '{modelName}' = '')
