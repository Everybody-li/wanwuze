-- ##Title web机构端-审批模式-切换合作项目-供应报价管理-拒绝报价-查看拒绝报价事由
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 表名： coz_demand_request_supply
-- ##CallType[QueryData]

-- ##input requestSupplyGuid char[36] NOTNULL;需求供方guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output refusePriceReason string[300] 拒绝把报价事由;

select
t.refuse_price_reason as refusePriceReason
from
coz_demand_request_supply t
where 
t.guid='{requestSupplyGuid}' and t.del_flag='0'