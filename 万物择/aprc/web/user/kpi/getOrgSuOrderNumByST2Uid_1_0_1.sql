-- ##Title web-供应专员-查询供应专员成果列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-供应专员-查询供应专员成果列表
-- ##CallType[QueryData]

-- ##input staffUserId char[36] NOTNULL;用户id(登录用户id)，必填
-- ##input orgName string[50] NULL;供应机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
*
,(select count(1) from coz_serve_order_kpi where supply_gauser_id=t.staff_user_id and del_flag=''0'') as orderNum
from
(
select
t2.guid as orgGuid
,t2.name as orgName
,left(t2.create_time,16) as createTime
,t1.staff_user_id
from
coz_org_relate_staff_log t1
inner join
coz_org_info t2
on t1.org_user_id=t2.user_id
where
t1.staff_type=''2'' and t1.staff_user_id=''{staffUserId}'' and t1.del_flag=''0'' and (t2.name like ''%{orgName}%'' or ''{orgName}''='''')
group by t2.guid,t2.name,left(t2.create_time,16),t1.staff_user_id
) t
order by t.createTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;