-- ##Title web-查询品类类型验收期限列表-未设置_1_0_1

-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询类型验收期限列表-未设置_1_0_1

-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid string[50] 品类类型guid;品类类型guid
-- ##output categoryName string[50] 品类类型名称;品类类型名称

	select
	t.guid as categoryGuid
	,t.name as categoryName
	from
	coz_cattype_fixed_data t
inner join
coz_category_deal_deadline t1
on t.guid=t1.category_guid
where t1.day='0' and t.del_flag='0' and t1.del_flag='0'
order by norder