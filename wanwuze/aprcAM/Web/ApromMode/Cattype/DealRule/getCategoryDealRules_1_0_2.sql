-- ##Title web-查询品类名称下的节点交易规则管理列表_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类名称下的节点交易规则管理列表_1_0_1
-- ##CallType[QueryData]

-- ##input categoryName string[500] NULL;品类名称，非必填
-- ##input categoryMode enum[1,2,3] NOTNULL;品类模式：1-沟通模式，2-交易模式，3-审批模式
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output dealRuleGuid string[50] 规则记录guid;规则记录guid
-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output publishFlag int[>=0] 1;发布按钮高亮标志（0：置灰，1：高亮）
-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output createTime string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）

	select
	t.guid as dealRuleGuid
	,t1.cattype_name as cattypeName
	,t.category_guid as categoryGuid
	,t1.name as categoryName
	,case when(t.publish_flag='0') then '1' else '0' end as publishFlag
	,left(t.publish_time,16) as publishTime
	,left(t.create_time,19) as createTime
	from
	coz_category_deal_rule t
	left join
	coz_category_info t1
	on t.category_guid=t1.guid
	where  t1.mode='{categoryMode}' and t.del_flag='0'
	        {dynamic:categoryName[ and t1.name like '%{categoryName}%']/dynamic}
order by t.id desc
;

