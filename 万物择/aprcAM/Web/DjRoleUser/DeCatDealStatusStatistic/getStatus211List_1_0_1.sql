-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-交易模式-查看详情(采购需求提交)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类采购交易状态下的采购需求提交信息
-- ##Describe 其他过滤条件:t2.需求未取消,未交易完成
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_demand_request t2
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
-- ##output categoryName string[500] ;品类名称
-- ##output cattypeName string[50] ;品类类型名称
-- ##output bizGuid string[36] 业务guid;业务guid

select left(dr.create_time, 19) as operationTime211
     , dr.category_name         as categoryName
     , dr.cattype_name          as cattypeName
     , t1.biz_guid              as bizGuid 
from coz_server3_cate_dealstatus_statistic t1
         inner join coz_demand_request dr on t1.biz_guid = dr.guid
         left join coz_demand_request_supply drs on dr.guid = drs.request_guid
         left join coz_demand_request_supply_server3 drss3 on drs.guid = drss3.request_supply_guid
         left join coz_category_supplier cs on drs.supplier_guid = cs.guid
where t1.del_flag = '0'
  and dr.del_flag = '0'
  and t1.dstatus = '211'
  and (t1.demand_user_id = '{demandOrSupplyUserId}' or cs.user_id = '{demandOrSupplyUserId}' or
       '{demandOrSupplyUserId}' = '')
  and dr.cancel_flag = '0'
  and dr.done_flag = '0'
  and t1.sd_path_guid = '{sdPathGuid}'
  and (dr.category_name like '%{categoryName}%' or '{categoryName}' = '')
  and (('{targetUserType}' = '1' and t1.demand_sys_user_guid = '{targetUserId}') or
       ('{targetUserType}' = '2' and drss3.sys_user_guid = '{targetUserId}') or
       ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}') or
       ('{targetUserType}' = '4' and t1.sd_path_guid = '{targetUserId}'))
 and not exists(select 1
                         from coz_demand_request_supply
                         where dr.guid = request_guid and price_status in ('2', '3'))
group by operationTime211,categoryName,cattypeName,bizGuid
order by operationTime211 desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



