-- ##Title web-查询供方指派规则列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供方指派规则列表
-- ##CallType[QueryData]

-- ##input categoryName string[20] NULL;品类名称，非必填
-- ##input curUserId string[36] MOTNULL;登录用户id，必填

-- ##output assignGuid char[36] 指派规则guid;指派规则guid
-- ##output categoryGuid char[36] 品类名称guid;品类名称guid
-- ##output categoryName string[20] 供应类型全名称;供应类型全名称
-- ##output cattypeName string[200] 品类类型名称;品类类型名称
-- ##output publishFlag int[>=0] 0;发布按钮高亮标志（0：置灰，1：高亮）
-- ##output publishTime string[19] 最新已发布时间;最新已发布时间（格式：0000年00月00日 00:00）
-- ##output createTime string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）

select
t.category_guid as categoryGuid
,t1.cattype_guid as cattypeGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
,case when exists(select 1 from coz_category_model_supply_assign where category_guid=t.category_guid and del_flag='0' and publish_flag='0') then '2' else '0' end as publishFlag
,t.publish_time as publishTime
,t.create_time as createTime
from
coz_category_model_supply_assign t
left join
coz_category_info t1
on t.category_guid=t1.GUID
where 
(t1.name like '%{categoryName}%'  or '{categoryName}'='') and t.del_flag='0' and t1.del_flag='0'
order by t.create_time desc