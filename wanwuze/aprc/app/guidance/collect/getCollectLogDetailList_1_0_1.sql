-- ##Title app-对象领取统计-详情列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-对象领取统计-详情列表

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input createTime string[10] NOTNULL;日期（某一天）（格式：0000-00-00）
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
*
from
(
select 
t.guid as guserRecordLogGuid
,t.guser_record_guid as guserRecordGuid
,t.phonenumber
,t.nation as nation
,t.guided_username as userName
,t.guided_user_id as userId
,t.id
from 
coz_guidance_user_record_log t
where t.user_id=''{curUserId}'' and left(t.create_time,10)=''{createTime}''
)t
order by id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;