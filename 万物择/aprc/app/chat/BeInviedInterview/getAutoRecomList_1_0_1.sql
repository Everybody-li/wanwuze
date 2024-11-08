-- ##Title app-应聘-应聘进展管理-受邀信息接收-系统推荐管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe coz_chat_supply_request t1,coz_chat_supply_request_demand t2,coz_chat_supply_request_demand_detail t3
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output sdPathGuid char[36] 采购供应路径Guid;
-- ##output userId char[36] 招聘方用户id;
-- ##output categoryGuid char[36] t3.品类名称Guid;
-- ##output categoryName string[50] 品类名称;
-- ##output categoryAlias string[50] 品类名称别名;
-- ##output categoryImg string[50] 品类名称图片;
-- ##output recruitGuid char[36] 招聘信息Guid ;
-- ##output requestSupplyGuid char[36] 需求招聘Guid;
-- ##output supplyCreateTime string[16] 推荐日期(0000-00-00 00:00);
-- ##output salesOn string[1] 1;上下架状态(1：上架，2：下架);
-- ##output deRequestGuid char[36] t3的字段，沟通(应聘)需求Guid;
-- ##output deUserId char[36] 应聘方用户id;
-- ##output deUserName string[50] 应聘方用户姓名;

PREPARE q1 FROM '
select
t1.sd_path_guid as sdPathGuid
,t1.user_id as userId
,t4.guid as categoryGuid
,t4.name as categoryName
,t4.alias as categoryAlias
,t4.img as categoryImg
,t1.guid as recruitGuid
,t2.guid as requestSupplyGuid
,left(t2.create_time,16) as supplyCreateTime
,t1.sales_on as salesOn
,t3.guid as deRequestGuid
,t3.user_id as deUserId
,t3.user_name as deUserName
from
coz_chat_employ t1
left join
coz_chat_supply_request_demand t2
on t2.recruit_guid=t1.guid and t2.del_flag=''0''
left join
coz_chat_supply_request t3
on t2.de_request_guid=t3.guid
left join
coz_category_info t4
on t1.category_guid=t4.guid
where 
t1.sd_path_guid=''{sdPathGuid}'' and t1.user_id=''{curUserId}'' and t2.recommend_type=''2''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
