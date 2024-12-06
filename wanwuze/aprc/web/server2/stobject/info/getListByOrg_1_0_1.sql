-- ##Title web-查询目标用户选择列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询目标用户选择列表
-- ##CallType[QueryData]

-- ##input orgName string[60] NULL;机构名称(模糊搜索)，非必填
-- ##input orgType string[30] NOTNULL;机构类型名称，必填
-- ##input registerCity string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input roleType string[30] NOTNULL;角色类型名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
t1.guid as objectOrgGuid
,t1.object_guid as objectGuid
,concat(''(+86)'',t2.phonenumber) as phonenumber
,t2.name as nickName
,t1.org_name as orgName
,t1.r_type as roleType
,t1.org_type as orgType
,t1.register_city as registerCity
from
coz_target_object_org t1
inner join
coz_target_object t2
on t2.guid=t1.object_guid
where 
(t1.org_name like''%{orgName}%'' or ''{orgName}''='''') and t1.del_flag=''0'' and t1.org_type=''{orgType}'' and t1.register_city=''{registerCity}'' and t1.r_type=''{roleType}''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;