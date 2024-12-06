-- ##Title 判断品类名称是否存在
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 判断品类名称是否存在
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
sum(num) as num
from
(
select count(1) as num from coz_category_info where guid='{categoryGuid}'and del_flag='0'
union all
select count(1) as num from coz_cattype_fixed_data where guid='{categoryGuid}'and del_flag='0'
)t