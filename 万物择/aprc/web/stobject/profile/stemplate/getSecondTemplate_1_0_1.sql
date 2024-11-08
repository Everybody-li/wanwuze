-- ##Title web-查询订单成果详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询订单成果详情
-- ##CallType[QueryData]

select 
guid as profileTemplateGuid
,first_fixed_gname as firstFixedGName
,second_fixed_gname as secondFixedGName
,type
from 
coz_target_object_profile_template
where 
type='{type}' and del_flag='0'

