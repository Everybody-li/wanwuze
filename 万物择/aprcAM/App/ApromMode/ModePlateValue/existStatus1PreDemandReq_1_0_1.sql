-- ##Title app-管理-审批模式下的品类-融资渠道选择-渠道需求页面加载-是否需要展示最近一次需求内容
-- ##Author lith
-- ##CreateTime 2023-12-04
-- ##Describe 当前品类的用户,存在有效未删除的需求,则展示,否则不展示
-- ##Describe 表名：coz_aprom_pre_demand_request
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output existFlag int[>=0] 1;0-不展示,>0 :展示
-- ##output preRequestGuid char[36] ;渠道需求guid

select count(1) as existFlag, guid as preRequestGuid
from coz_aprom_pre_demand_request t
where t.category_guid = '{categoryGuid}'
  and user_id = '{curUserId}'
  and t.del_flag = '0'
  and t.status = '1'
;