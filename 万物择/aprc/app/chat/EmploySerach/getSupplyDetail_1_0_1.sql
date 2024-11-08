-- ##Title app-招聘-招聘方式管理-应聘人员查找-查看应聘人员-查看简历(主表品类及用户姓名等信息)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询应聘人员详情
-- ##CallType[QueryData]

-- ##input recruitGuid char[36] NOTNULL;应聘工作信息Guid，必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid，必填
-- ##input supplyUserId char[36] NOTNULL;供方用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid char[36] 品类名称guid;
-- ##output categoryName string[50] 品类名称;
-- ##output categoryImg string[50] 品类名称图片;
-- ##output nickName string[50] 用户姓名;
-- ##output suImgs.img string[50] 应聘方工作简历图片;

select
t1.category_guid as categoryGuid
,t2.name as categoryName
,t2.img as categoryImg
,t3.user_name as nickName
,CONCAT('{ChildRows_aprc\\app\\chat\\EmploySerach\\getSupplyImgs_1_0_1:userId=''',t1.user_id,'''}') as `suImgs`
from
coz_chat_employ t1
inner join
coz_category_info t2
on t1.category_guid=t2.guid
inner join
sys_app_user t3
on t1.user_id=t3.guid
where 
t1.user_id='{supplyUserId}' and t1.guid='{recruitGuid}' and t1.sd_path_guid='{sdPathGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0'