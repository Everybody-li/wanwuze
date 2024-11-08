-- ##Title app-应聘-查询所有投递等待的需求列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-应聘-查询所有投递等待的需求列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t.sd_path_guid as sdPathGuid
,t.user_id as userId
,t.guid as deRequestGuid
,t.category_guid as categoryGuid
,t.category_name as categoryName
,t.category_img as categoryImg
,t.category_alias as categoryAlias
,left(t.create_time,16) as reqCreateTime
,(select count(1) from coz_chat_demand_request_supply where de_request_guid=t.guid and recommend_type=''2'') as recruitCount
,(select count(1) from coz_chat_demand_request_supply where de_request_guid=t.guid and recommend_type=''2'' and deuser_read_flag=''2'') as deUserUnReadCount
,t.cancel_flag as cancelFlag
from
coz_chat_demand_request t
where 
t.sd_path_guid=''{sdPathGuid}'' and t.del_flag=''0''  and t.send_type=''2'' and t.user_id=''{curUserId}'' 
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;