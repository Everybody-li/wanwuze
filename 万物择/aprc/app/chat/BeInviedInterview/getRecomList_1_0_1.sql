-- ##Title app-应聘-应聘进展管理-受邀信息接收-受邀记录管理-查询列表
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
-- ##output recruitGuid char[36] 招聘信息Guid; 
-- ##output recruitCreateTime string[16] 的创建日期(0000-00-00 00:00);
-- ##output salesOn string[1] 1;上下架状态(1：上架，2：下架);
-- ##output deUserCount int[>=0] 统计每个招聘信息对应的应聘者已投递数量;
-- ##output recruitUnReadCount string[1] 1;未阅读数量(后端：统计每个招聘信息对应的应聘者已投递未阅读的数量，app端：未阅读数量>0，展示红点);

PREPARE q1 FROM '
select
t1.sd_path_guid as sdPathGuid
,t1.user_id as userId
,t2.guid as categoryGuid
,t2.name as categoryName
,t2.alias as categoryAlias
,t2.img as categoryImg
,t1.guid as recruitGuid
,left(t1.create_time,16) as recruitCreateTime
,t1.sales_on as salesOn
,(select count(1) from coz_chat_supply_request_demand a inner join coz_chat_friend_apply b on a.guid=b.request_supply_guid where a.del_flag=''0'' and b.del_flag=''0'' and a.recruit_guid=t1.guid and a.send_resume_flag=''1'' and a.recommend_type=''1'') as deUserCount
,(select count(1) from coz_chat_supply_request_demand a inner join coz_chat_friend_apply b on a.guid=b.request_supply_guid where a.del_flag=''0'' and b.del_flag=''0'' and a.recruit_guid=t1.guid and a.send_resume_flag=''1'' and a.recruit_read_flag=''2'' and a.recommend_type=''1'') as recruitUnReadCount
from
coz_chat_employ t1
left join
coz_category_info t2
on t1.category_guid=t2.guid
where 
t1.sd_path_guid=''{sdPathGuid}'' and t1.user_id=''{curUserId}''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;