-- ##Title app-招聘-招聘进展管理-邀约信息管理-邀约记录管理-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-14
-- ##Describe 
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
from
coz_chat_supply_request t
where 
t.sd_path_guid=''{sdPathGuid}'' and t.del_flag=''0'' and t.send_type=''1'' and t.user_id=''{curUserId}''
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;