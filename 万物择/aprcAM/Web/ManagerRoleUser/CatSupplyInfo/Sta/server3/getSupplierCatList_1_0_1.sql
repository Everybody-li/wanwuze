-- ##Title web-运营经理操作管理-品类供应管理-供应渠道信息管理-供应渠道品类管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe
-- ##Describe 表名:coz_category_supplier t1,coz_category_info t2 coz_category_supplydemand t3,coz_category_scene_tree t4,coz_cattype_sd_path t5,coz_lgcode_fixed_data t6
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input orgUserId char[36] NOTNULL;供应机构用户id
-- ##input categoryName String[500] NULL;品类名称(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input lgcodeGuid string[36] NOTNULL;供应机构code

-- ##output orgUserId char[36] ;供应机构用户id
-- ##output categoryName string[500] ;品类名称
-- ##output cattypeName string[50] ;品类类型名称
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output supplierGuid char[36] ;供方品类guid

select 
t1.user_id as orgUserId
,t2.name as categoryName
,t2.cattype_name as cattypeName
,t2.img as categoryImg
,t2.alias as categoryAlias
,t1.guid as supplierGuid
from 
coz_category_supplier t1
inner join
coz_category_info t2
on t1.category_guid=t2.guid
inner join
coz_category_supplydemand t3
on t2.guid=t3.category_guid
inner join
coz_category_scene_tree t4
on t3.scene_tree_guid=t4.guid
inner join
coz_cattype_sd_path t5
on t4.sd_path_guid=t5.guid
where 
t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t4.del_flag='0' and t5.del_flag='0' and t1.user_id='{orgUserId}' and (t2.name like '%{categoryName}%' or '{categoryName}'='') and t5.lgcode_guid='{lgcodeGuid}'
Limit {compute:[({page}-1)*{size}]/compute},{size};