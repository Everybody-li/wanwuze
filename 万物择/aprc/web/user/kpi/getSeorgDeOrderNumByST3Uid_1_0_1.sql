-- ##Title web-招募专员成果-查询采购对接成果列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-招募专员成果-查询采购对接成果列表
-- ##CallType[QueryData]

-- ##input staffUserId char[36] NOTNULL;用户id(登录用户id)，必填
-- ##input seorgName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
t2.guid as seorgGuid
,t2.user_name as seorgName
,left(t2.create_time,16) as createTime
,(select count(1) from coz_serve_order_kpi where demand_seorg_stalog_st3_guid=t1.guid and del_flag=''0'') as orderNum
from
coz_serve_org_relate_staff_log t1
inner join
coz_serve_org t2
on t1.seorg_guid=t2.guid
where
t1.staff_type=''3'' and t1.staff_user_id=''{staffUserId}'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.user_name like ''%{seorgName}%'' or ''{seorgName}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;