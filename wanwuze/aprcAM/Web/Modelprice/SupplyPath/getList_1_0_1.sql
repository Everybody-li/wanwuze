-- ##Title web后台-审批报价配置管理-xx供应路径-查询顶部标签数据
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询 品类类型模式为审批模式的供应路径数据
-- ##Describe coz_cattype_sd_path t1,coz_cattype_supply_path t2,coz_cattype_fixed_data t3
-- ##CallType[QueryData]

-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input catMode enum[1,2,3] NOTNULL;品类模式:1-沟通模式,2-交易模式,3-审批模式

-- ##output cattypeGuid char[36] 品类类型guid;
-- ##output sdPathGuid char[36] 采购供应路径guid;
-- ##output supplyPathGuid char[36] 供应路径guid;
-- ##output supplyPathName string[100] 供应路径名称(格式：资金资源需求>管理>债权资金申请);

select
t2.cattype_guid as cattypeGuid
,t1.guid as sdPathGuid
,t2.guid as supplyPathGuid
,t2.all_path_name as supplyPathName
from
coz_cattype_sd_path t1
inner join
coz_cattype_supply_path t2
on t1.supply_path_guid=t2.guid
inner join
coz_cattype_fixed_data t3
on t2.cattype_guid=t3.guid
where t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t3.mode={catMode}
order by t1.id


