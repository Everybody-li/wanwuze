-- ##Title web-查询类型节点交易规则管理列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询类型节点交易规则管理列表_1_0_1
-- ##CallType[QueryData]

-- ##input categoryMode enum[1,2,3] NOTNULL;品类模式：1-沟通模式，2-交易模式，3-审批模式
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


-- ##output dealRuleGuid string[50] 规则记录guid;规则记录guid
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output publishFlag int[>=0] 1;发布按钮高亮标志（0：置灰，1：高亮）
-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output createTime string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）

	select
	t1.guid as dealRuleGuid
	,t1.cattype_guid as categoryGuid
	,case when(t1.publish_flag='0') then '1' else '0' end as publishFlag
	,right(t1.publish_time,19) as publishTime
	,t1.create_time as createTime
	,t.name as cattypeName
	from
	coz_cattype_fixed_data t
	inner join
	coz_category_deal_rule t1
	on t.guid=t1.category_guid
	where 
	t.del_flag='0' and t1.del_flag='0' and t.mode='{categoryMode}'

order by t.norder
