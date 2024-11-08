-- ##Title web-查询机构名称信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询机构名称信息列表
-- ##CallType[QueryData]

-- ##input orgName string[50] NULL;机构名称或手机号(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orgID string[18] 机构账号ID;机构账号ID

PREPARE q1 FROM '
select 
t.guid as orgGuid
,t.user_id as orgUserId
,t.name as orgName
,t.org_ID as orgID
,case when(t.phonenumber='''') then ''未设置'' else concat(''(+86)'',t.phonenumber) end as phonenumber
,left(t.create_time,16) as createTime
from 
coz_org_info t
where 
(t.name like''%{orgName}%'' or t.phonenumber like''%{orgName}%'') and t.del_flag=''0''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;