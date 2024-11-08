-- ##Title app-查询接收到的投递记录信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询接收到的投递记录信息列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

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
,(select count(1) from coz_chat_demand_request_supply a inner join coz_chat_friend_apply b on a.guid=b.request_supply_guid where a.del_flag=''0'' and b.del_flag=''0'' and a.recruit_guid=t1.guid and a.send_resume_flag=''1'' and a.recommend_type=''1'') as deUserCount
,(select count(1) from coz_chat_demand_request_supply a inner join coz_chat_friend_apply b on a.guid=b.request_supply_guid where a.del_flag=''0'' and b.del_flag=''0'' and a.recruit_guid=t1.guid and a.send_resume_flag=''1'' and a.recruit_read_flag=''2'' and a.recommend_type=''1'') as recruitUnReadCount
from
coz_chat_recruit t1
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