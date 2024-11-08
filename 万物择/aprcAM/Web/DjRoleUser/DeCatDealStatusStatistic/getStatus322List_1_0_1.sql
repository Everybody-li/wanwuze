-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-审批模式-查看详情(订单验收通过)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类采购交易状态下的订单验收通过信息,t1.业务guid=t2.guid
-- ##Describe 其他过滤条件:t2.需方验收通过的
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t2,coz_demand_request t3,coz_demand_request_supply t4
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input categoryName string[500] NULL;品类名称,模糊搜索
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input demandOrSupplyUserId char[36] NULL;需方用户id或供方用户id

-- ##output operationTime322 char[19] 2023-12-12 12:12:12;订单验收通过日期
-- ##output categoryName string[500] ;品类名称
-- ##output cattypeName string[50] ;品类类型名称
-- ##output orgName string[100] ;供应机构(渠道)名称
-- ##output modelName string[50] ;型号名称
-- ##output orderNo char[24] 2023091110301211;采购编号
-- ##output demandUserPhone string[50] (+86)18650767213;需方信息
-- ##output bizGuid string[36] 业务guid;业务guid

select left(t2.accept_time, 19)       as operationTime322
     , t3.category_name               as categoryName
     , t3.cattype_name                as cattypeName
     , t2.order_no                    as orderNo
     , t1.supply_user_name            as orgName
     , t5.model_name                  as modelName
     , concat('(+86)', t3.user_phone) as demandUserPhone
     , t1.biz_guid              as bizGuid 
from coz_server3_cate_dealstatus_statistic t1
         inner join coz_order t2 on t1.biz_guid = t2.guid
         inner join coz_demand_request t3 on t2.request_guid = t3.guid
         inner join coz_demand_request_price t4 on t2.request_price_guid = t4.guid
         inner join coz_demand_request_supply t5 on t4.request_supply_guid = t5.guid
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t3.del_flag = '0'
  and t4.del_flag = '0'
  and t1.dstatus = '322'
  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
       '{demandOrSupplyUserId}' = '')
  and t2.accept_status = '1'
  and t1.sd_path_guid = '{sdPathGuid}'
  and (t3.category_name like '%{categoryName}%' or '{categoryName}' = '')
  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
order by t2.accept_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



