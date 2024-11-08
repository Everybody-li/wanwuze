-- ##Title web-根据品类名称查询询价专员信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-根据品类名称查询询价专员信息
-- ##CallType[QueryData]

-- ##input categoryGuid string[36] NOTNULL;品类guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.user_name as userName
,t1.nick_name as nickName
,t1.phonenumber
,left(t1.create_time,10) as createTime
,left(t2.create_time,10) as grantTime
,case when (t2.del_flag=''0'') then '''' else left(t2.update_time,10) end as unGrantTime
from 
sys_user t1
inner join
coz_server2_sys_user_category t2
on t1.user_id=t2.user_id
where 
t1.del_flag=''0'' and t2.category_guid=''{categoryGuid}''
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;