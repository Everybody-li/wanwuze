-- ##Title app-招聘-查询系统推荐设置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-招聘-查询系统推荐设置列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

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
coz_chat_recruit t1
left join
coz_chat_demand_request_supply t2
on t2.recruit_guid=t1.guid and t2.del_flag=''0''
left join
coz_chat_demand_request t3
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
