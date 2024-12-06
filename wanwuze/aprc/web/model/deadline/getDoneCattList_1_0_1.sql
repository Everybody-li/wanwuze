-- ##Title web-查询类型验收期限列表-已设置_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询类型验收期限列表-已设置_1_0_1
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid string[50] 品类类型guid;品类类型guid
-- ##output categoryName string[50] 品类类型名称;品类类型名称

	select
	t1.guid as categoryGuid
	,t1.name as categoryName
	,t.day
	,left(t.update_time,10) as updateTime
	from
	coz_category_deal_deadline t
	inner join
	coz_cattype_fixed_data t1
	on t.category_guid=t1.guid
where t.del_flag='0' and t1.del_flag='0' and exists(select 1 from coz_category_deal_deadline_log where deadline_guid=t.guid)
order by t1.norder