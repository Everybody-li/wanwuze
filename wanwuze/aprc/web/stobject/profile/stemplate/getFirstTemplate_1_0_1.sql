-- ##Title web-查询订单成果详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询订单成果详情
-- ##CallType[QueryData]

-- ##input type string[1] NOTNULL;登录用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
firstFixedGName
,type
,CONCAT('{ChildRows_aprc\\web\\stobject\\profile\\stemplate\\getSecondTemplate_1_0_1:type=''',t.type,''' and firstFixedGName=''',t.firstFixedGName,'''}') as data
from
(
		select 
		first_fixed_gname as firstFixedGName
		,type
		,min(id) as id
		from 
		coz_target_object_profile_template
		where 
		type='{type}' and del_flag='0'
		group by first_fixed_gname,type
)t
order by id