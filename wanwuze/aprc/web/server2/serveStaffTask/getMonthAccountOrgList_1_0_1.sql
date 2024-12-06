-- ##Title web-查看服务专员的机构账号开通详情列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看服务专员的机构账号开通详情列表
-- ##CallType[QueryData]

-- ##input orgName string[80] NULL;服务对象guid，必填
-- ##input month string[7] NOTNULL;月份(格式：0000-00)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t2.guid as orgGuid
,t2.name as orgName
,left(t2.account_time,16) as orgCreateTime
from 
coz_org_info t2
inner join
sys_user t3
on t3.user_id=t2.account_by
where 
t2.del_flag=''0'' and t3.del_flag=''0'' and t3.status=''0''  and t2.account_by=''{curUserId}'' and left(t2.account_time,7)=''{month}'' and (t2.name like ''%{orgName}%'' or ''{orgName}''='''')
order by t2.account_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;