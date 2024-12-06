-- ##Title web-查询服务机构最近收回授权的品类类型
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务机构最近收回授权的品类类型
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input seorgGuid char[36] NOTNULL;服务机构信息guid，必填



select
t1.cattype_name as cattypeName
from
coz_serve_org_category_log t
inner join
coz_category_info t1
on t.category_guid=t1.guid
where t1.del_flag='0' and t.del_flag='0' and t.seorg_guid='{seorgGuid}' and t.cattype_ungrant='0'
group by t1.cattype_name