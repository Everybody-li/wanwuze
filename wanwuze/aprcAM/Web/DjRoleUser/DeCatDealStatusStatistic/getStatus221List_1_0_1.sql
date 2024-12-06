-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户采购管理/供应渠道供应管理-交易模式-查看详情(退款退货订单)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类采购交易状态下的退款退货订单信息,,t1.业务guid=t2.guid
-- ##Describe 其他过滤条件:t2.仲裁结果为 是供方或需方违约,支持退款的
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_order_judge t2,coz_order_cancel t3,coz_order_refund t4,coz_order t5,coz_demand_request t6
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input categoryName string[500] NULL;品类名称,模糊搜索
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input demandOrSupplyUserId char[36] NULL;需方用户id或供方用户id

-- ##output operationTime221 char[19] 2023-12-12 12:12:12;退款退货到账日期
-- ##output operationTime219 char[19] 2023-12-12 12:12:12;订单交易仲裁日期
-- ##output orderNo char[24] 2023091110301211;采购编号
-- ##output categoryName string[500] ;品类名称
-- ##output cattypeName string[50] ;品类类型名称
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息
-- ##output bizGuid string[36] 业务guid;业务guid

select *
from (select left(t5.create_time, 19) as operationTime221
           , left(t4.result_time, 19) as operationTime219
           , t3.order_no              as orderNo
           , t2.category_name         as categoryName
           , t2.cattype_name          as cattypeName
           , t1.biz_guid              as bizGuid 
      from coz_server3_cate_dealstatus_statistic t1
               inner join coz_order_judge t4 on t1.biz_guid = t4.guid
               inner join coz_order t3 on t3.guid = t4.order_guid
               inner join coz_order_cancel t5 on t5.guid = t4.biz_guid
               inner join coz_demand_request t2 on t2.guid = t3.request_guid
      where t1.del_flag = '0'
        and t2.del_flag = '0'
        and t3.del_flag = '0'
        and t4.del_flag = '0'
        and t5.del_flag = '0'
        and t1.dstatus = '221'
        and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
             '{demandOrSupplyUserId}' = '')
        and (t4.result = '1' or t4.result = '2')
        and t1.sd_path_guid = '{sdPathGuid}'
        and (t2.category_name like '%{categoryName}%' or '{categoryName}' = '')
        and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
      union all
      select left(t5.create_time, 19) as operationTime221
           , left(t4.result_time, 19) as operationTime219
           , t3.order_no              as orderNo
           , t2.category_name         as categoryName
           , t2.cattype_name          as cattypeName
           , t1.biz_guid              as bizGuid 
      from coz_server3_cate_dealstatus_statistic t1
               inner join coz_order_judge t4 on t1.biz_guid = t4.guid
               inner join coz_order t3 on t3.guid = t4.order_guid
               inner join coz_order_refund t5 on t5.guid = t4.biz_guid
               inner join coz_demand_request t2 on t2.guid = t3.request_guid
      where t1.del_flag = '0'
        and t2.del_flag = '0'
        and t3.del_flag = '0'
        and t4.del_flag = '0'
        and t5.del_flag = '0'
        and t1.dstatus = '221'
        and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
             '{demandOrSupplyUserId}' = '')
        and (t4.result = '1' or t4.result = '2')
        and t1.sd_path_guid = '{sdPathGuid}'
        and (t2.category_name like '%{categoryName}%' or '{categoryName}' = '')
        and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})) t1
order by operationTime221 desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



