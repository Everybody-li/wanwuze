-- ##Title web-交易条件管理-查询交易组织跟踪管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询手机号更新记录
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input cattypeGuid char[36] NULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
,(select count(1) from (select a.category_guid from coz_category_supplier a where a.del_flag=''0'' and exists(select 1 from coz_org_info where del_flag=''0'' and user_id=a.user_id)  group by a.category_guid,a.user_id)a where a.category_guid=t1.guid) as supplyOrgNum
,(select count(1) from (select category_guid from coz_serve_org_category a where a.del_flag=''0'' and exists(select 1 from coz_serve_org where del_flag=''0'' and guid=a.seorg_guid) group by category_guid,seorg_guid)b where b.category_guid=t1.guid) as waiterOrgNum
from 
coz_category_info t1
where t1.del_flag=''0'' and t1.mode=2 and (t1.name like ''%{categoryName}%''or ''{categoryName}''='''') and t1.cattype_guid=''{cattypeGuid}''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;