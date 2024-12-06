-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-交易模式-查看详情(供方供应报价)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类采购交易状态下的供方供应报价信息,t1.业务guid=t2.guid
-- ##Describe 其他过滤条件:t2.需求未取消,未交易完成,t2在t3中存在已报价的
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_demand_request t2,coz_demand_request_supply t3
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input categoryName string[500] NULL;品类名称,模糊搜索
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input demandOrSupplyUserId char[36] NULL;需方用户id或供方用户id

-- ##output operationTime211 char[19] 2023-12-12 12:12:12;采购需求提交日期
-- ##output operationTime212 char[19] 2023-12-12 12:12:12;供方供应报价日期
-- ##output categoryName string[500] ;品类名称
-- ##output cattypeName string[50] ;品类类型名称
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息
-- ##output bizGuid string[36] 业务guid;业务guid

# 212状态不会存t1,交易模式供方报价是一个需求多个供方报价,通过业务表进行计算而得
select left(t1.create_time, 19)       as operationTime211
     , left(t3.price_time, 19)        as operationTime212
     , t2.category_name               as categoryName
     , t2.cattype_name                as cattypeName
     , concat('(+86)', t3.user_phone) as supplyUserPhone
     , t1.biz_guid              as bizGuid 
from coz_server3_cate_dealstatus_statistic t1
         inner join coz_demand_request t2 on t1.biz_guid = t2.guid
         inner join coz_demand_request_supply t3 on t2.guid = t3.request_guid
         left join coz_demand_request_supply_server3 drss3 on t3.guid = drss3.request_supply_guid
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
  and t1.dstatus = '211'
  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
       '{demandOrSupplyUserId}' = '')
  and t3.price_status = '3'
  and t2.cancel_flag = '0'
  and t2.done_flag = '0'
  and t1.sd_path_guid = '{sdPathGuid}'
  and (t2.category_name like '%{categoryName}%' or '{categoryName}' = '')
  and ( ('{targetUserType}' = '1' and t1.demand_sys_user_guid = '{targetUserId}') or
                        ('{targetUserType}' = '2' and drss3.sys_user_guid = '{targetUserId}') or
                        ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}') or
                        ('{targetUserType}' = '4' and t1.sd_path_guid = '{targetUserId}')
                     )
order by t1.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



