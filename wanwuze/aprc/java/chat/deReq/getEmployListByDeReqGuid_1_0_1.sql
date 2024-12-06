-- ##Title 沟通模式根据应聘需求guid查询已推荐的应聘信息guid列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 沟通模式根据应聘需求guid查询已推荐的应聘信息guid列表
-- ##CallType[QueryData]

-- ##input deRequestGuid char[36] NOTNULL;招聘需求guid，必填
-- ##input recType string[1] NOTNULL;推荐类型(1：严格匹配规则推荐，2：宽松匹配规则推荐)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output recruitGuid char[36] 招聘信息Guid;
-- ##output recType string[1] 推荐类型;

select
t.recruit_guid as recruitGuid
,t.recommend_type as recType
from
coz_chat_supply_request_demand t
where 
t.de_request_guid='{deRequestGuid}' and t.del_flag='0' and t.recommend_type='{recType}'