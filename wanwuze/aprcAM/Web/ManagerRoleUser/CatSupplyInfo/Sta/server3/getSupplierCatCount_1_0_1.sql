-- ##Title web-运营经理操作管理-品类供应管理-供应渠道信息管理-供应渠道品类管理-列表上方-供应品类添加括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 统计t1的行数
-- ##Describe 表名:coz_category_supplier t1
-- ##CallType[QueryData]

-- ##input orgUserId char[36] NOTNULL;供应机构用户id
-- ##input categoryName String[500] NULL;品类名称(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input lgcodeGuid string[36] NOTNULL;供应机构code

-- ##output totalNum int[>=0] ;供应品类添加数量


select 
count(1) as totalNum 
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
t1.del_flag='0' and t2.del_flag='0' and t1.user_id='{orgUserId}' and (t2.name like '%{categoryName}%' or '{categoryName}'='') and t5.lgcode_guid='{lgcodeGuid}'