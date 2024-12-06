-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-交易模式-查看详情(采购需求支付)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类采购交易状态下的采购需求支付信息,t1.业务guid=t2.guid
-- ##Describe 其他过滤条件:t2.订单支付成功,t3.需求已交易完成,(t2.guid在t4中不存在或t2.guid在t4中存在且t4.result=维持交易)
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order t2,coz_demand_request t3,coz_order_judge t4
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input categoryName string[500] NULL;品类名称,模糊搜索
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input demandOrSupplyUserId char[36] NULL;需方用户id或供方用户id

-- ##output operationTime214 char[19] 2023-12-12 12:12:12;采购需求支付日期
-- ##output operationTime211 char[19] 2023-12-12 12:12:12;采购需求提交日期
-- ##output orderNo char[24] 2023091110301211;采购编号
-- ##output categoryName string[500] ;品类名称
-- ##output cattypeName string[50] ;品类类型名称
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息
-- ##output bizGuid string[36] 业务guid;业务guid

select left(dr.create_time, 19)              as operationTime211
     , left(corder.create_time, 19)          as operationTime214
     , corder.order_no                       as orderNo
     , dr.category_name                      as categoryName
     , dr.cattype_name                       as cattypeName
     , concat('(+86)', t1.supply_user_phone) as supplyUserPhone
     , t1.biz_guid                           as bizGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join coz_order corder on corder.guid = t1.biz_guid
         inner join coz_demand_request dr on corder.request_guid = dr.guid
         left join coz_order_judge cojudge on corder.guid = cojudge.order_guid
where t1.del_flag = '0'
  and dr.del_flag = '0'
  and t1.dstatus = '214'
  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
       '{demandOrSupplyUserId}' = '')
  and corder.pay_status = '2'
  and corder.accept_status = '0'
  and corder.supply_done_flag = '0'
  and dr.done_flag = '1'
  and cojudge.guid is null
  and t1.sd_path_guid = '{sdPathGuid}'
  and (dr.category_name like '%{categoryName}%' or '{categoryName}' = '')
  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
order by t1.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



