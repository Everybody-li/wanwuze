-- ##Title app-权限用户信息的权限详情-下半部分
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-权限用户信息的权限详情-下半部分

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input createTime string[10] NOTNULL;日期（某一天）（格式：0000-00-00）
-- ##input userName string[50] NULL;用户姓名(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
*
from
(
select 
t.guid as guserRecodGuid
,t.phonenumber
,t.nation as nation
,t.guided_username as username
,t.guided_user_id as userId
,t.id
from 
coz_guidance_user_record t
where t.user_id=''{curUserId}'' and left(t.create_time,10)=''{createTime}'' and (t.guided_username like ''%{userName}%'' or ''{userName}''='''') and t.take_back_flag=''0''
)t
order by id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;