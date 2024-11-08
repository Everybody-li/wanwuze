-- ##Title java-审批模式-渠道需求提交-渠道需求是否存在(返回渠道需求guid)
-- ##Author 卢文彪
-- ##CreateTime 2023-12-05
-- ##Describe 表名： coz_aprom_pre_demand_request
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;渠道需求guid

-- ##output guid char[36] ;渠道需求guid


select guid
from coz_aprom_pre_demand_request
where guid = '{requestGuid}'
  and del_flag = '0'
  and status = '1';