-- ##Title web-查询品类类型服务定价列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类类型服务定价列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryGuid string[50] 品类类型guid;品类类型guid
-- ##output categoryName string[50] 品类类型名称;品类类型名称

	select
	t.guid as categoryGuid
	,t.name as categoryName
	from
	coz_cattype_fixed_data t
where mode=2
order by norder