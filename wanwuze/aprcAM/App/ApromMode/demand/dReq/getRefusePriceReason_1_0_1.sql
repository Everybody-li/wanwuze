-- ##Title web机构端-审批模式-切换合作项目-供应报价管理-拒绝报价-查看拒绝报价事由
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 表名： coz_demand_request_supply
-- ##CallType[QueryData]

-- ##input requestGuid char[36] NOTNULL;需求guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output supplyCompanyName string[100] 供方主体;
-- ##output refusePriceReason string[300] 拒绝报价事由;
-- ##output refusePriceTime string[19] 拒绝报价时间;



# 审批模式下，一个需求只会有一个匹配上的供方
select t2.supply_company_name as supplyCompanyName
     , t.refuse_price_reason  as refusePriceReason
     , left(t.price_time,19)           as refusePriceTime
from coz_demand_request_supply t
         inner join coz_category_supplier_am_model t2 on t.model_guid = t2.guid
where t.request_guid = '{requestGuid}'
  and t.del_flag = '0';