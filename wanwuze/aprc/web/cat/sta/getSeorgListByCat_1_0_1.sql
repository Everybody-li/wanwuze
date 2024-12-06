-- ##Title web-交易条件管理-查询交易组织跟踪管理-服务机构数量详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易条件管理-查询交易组织跟踪管理-服务机构数量详情
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NULL;品类名称（后端支持模糊搜索），非必填
-- ##input seorgName string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
left(t1.create_time,16) as registerTime
,(select count(1) from coz_serve_org_relate_staff where seorg_guid=t1.guid and del_flag=''0'' and staff_type=''1'') as waiterNum
,t1.user_name as seorgName
,t1.guid as seorgGuid
from
coz_serve_org t1
where t1.del_flag=''0'' and exists(select 1 from coz_serve_org_category t2 where t2.seorg_guid=t1.guid and t2.del_flag=''0'' and t2.category_guid=''{categoryGuid}'') and (t1.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

