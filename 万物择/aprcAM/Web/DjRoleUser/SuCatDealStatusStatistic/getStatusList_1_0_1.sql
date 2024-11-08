-- ##Title web-对接专员操作管理-供方对接管理-供应渠道供应管理-审批模式/交易模式-各状态统计数据
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 需方对接专员的品类采购交易状态统计,t1作主表,统计t1在t2中关联的行数,t1在t2中没有关联数据的,则数量为0
-- ##Describe 其他过滤条件:入参品类guid有传值,则参与过滤,否则不参与
-- ##Describe 表名：coz_server3_cate_su_dealstatus t1,coz_server3_cate_dealstatus_statistic t2
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input mode enum[2,3] NOTNULL;品类模式:2-交易模式,3-审批模式
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output catDealStatusStr string[20] 渠道需求提交;状态(中文)
-- ##output catDealStatus int[>0] 211;状态枚举值
-- ##output totalNum int[>=0] 0;数量


select *
from (select case
                 when t1.dstatus = '213' then '需方删除需求'
                 when t1.dstatus = '214' then '需求采购支付'
                 when t1.dstatus = '215' then '供应取消订单'
                 when t1.dstatus = '216' then '需方取消订单'
                 when t1.dstatus = '217' then '供方供应完成'
                 when t1.dstatus = '218' then '需方申请退货'
                 when t1.dstatus = '219' then '订单交易仲裁'
                 when t1.dstatus = '220' then '订单验收通过'
                 when t1.dstatus = '221' then '退款退货订单'
                 when t1.dstatus = '311' then '渠道需求提交'
                 when t1.dstatus = '313' then '办理申请提交'
                 when t1.dstatus = '314' then '需方删除申请'
                 when t1.dstatus = '315' then '供应拒绝报价'
                 when t1.dstatus = '316' then '供方供应报价'
                 when t1.dstatus = '317' then '需求采购支付'
                 when t1.dstatus = '318' then '供应取消订单'
                 when t1.dstatus = '319' then '供方办理通知'
                 when t1.dstatus = '320' then '供方供应完成'
                 when t1.dstatus = '321' then '退款退货订单'
                 when t1.dstatus = '322' then '订单验收通过'
    end                                                                                as catDealStatusStr
           , t1.dstatus                                                                as catDealStatus
           , (select count(1)
              from coz_server3_cate_dealstatus_statistic
              where del_flag = '0'
                and dstatus = t1.dstatus
                and sd_path_guid = '{sdPathGuid}'
                and (('{targetUserType}' = '1' and demand_sys_user_guid = '{targetUserId}') or
                ('{targetUserType}' = '2' and supply_sys_user_guid = '{targetUserId}') or
                ('{targetUserType}' = '3' and category_guid = '{targetUserId}') or
                ('{targetUserType}' = '4' and sd_path_guid = '{targetUserId}'))) as totalNum
      from coz_server3_cate_su_dealstatus t1
      where t1.del_flag = '0'
        and t1.category_mode = '{mode}'
        and t1.dstatus <> 211
        and t1.dstatus <> 212
        and t1.dstatus <> 312
      union all
      select
          '采购需求提交'          as catDealStatusStr
        , 211                     as catDealStatus
        , count(distinct t1.guid) as totalNum
      from
          coz_demand_request                           t1
          inner join coz_demand_request_supply         t2 on t1.guid = t2.request_guid
          inner join coz_category_supplier             t3 on t2.supplier_guid = t3.guid
          left join  coz_demand_request_supply_server3 t4 on t2.guid = t4.request_supply_guid
      where
            t1.del_flag = '0'
        and t1.cancel_flag = '0'
        and t1.sd_path_guid = '{sdPathGuid}'
        and (t1.user_id = '{demandOrSupplyUserId}' or t3.user_id = '{demandOrSupplyUserId}' or
             '{demandOrSupplyUserId}' = '')
        and (('{targetUserType}' = '1' and t4.sys_user_guid = '{targetUserId}') or
             ('{targetUserType}' = '2' and t4.sys_user_guid = '{targetUserId}') or
             ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}') or
             ('{targetUserType}' = '4' and t1.sd_path_guid = '{targetUserId}'))
        and t1.cancel_flag = '0'
        and t1.done_flag = '0'
        and t2.price_status = '1'
      union all
      select '供方供应报价'          as catDealStatusStr
           , 212                     as catDealStatus
           , count(distinct t1.guid) as totalNum
      from coz_server3_cate_dealstatus_statistic t1
               inner join coz_demand_request t2 on t1.biz_guid = t2.guid
               inner join coz_demand_request_supply t3 on t2.guid = t3.request_guid
               inner join coz_category_supplier t4 on t3.supplier_guid = t4.guid
               left join coz_demand_request_supply_server3 t5 on t2.guid = t5.request_supply_guid
      where t1.del_flag = '0'
        and t2.del_flag = '0'
        and t2.cancel_flag = '0'
        and t1.sd_path_guid = '{sdPathGuid}'
        and (t1.demand_user_id = '{demandOrSupplyUserId}' or t4.user_id = '{demandOrSupplyUserId}' or
             '{demandOrSupplyUserId}' = '')
        and (('{targetUserType}' = 1 and t1.demand_sys_user_guid = '{targetUserId}')
          or ('{targetUserType}' = 2 and t5.guid is not null and t5.sys_user_guid = '{targetUserId}')
          or ('{targetUserType}' = 3 and t1.category_guid = '{targetUserId}'))
        and t2.cancel_flag = '0'
        and t2.done_flag = '0'
        and t3.price_status = '3'
      union all
      select '办理申请点击'          as catDealStatusStr
           , 312                     as catDealStatus
           , count(t2.guid) as totalNum
      from coz_server3_cate_dealstatus_statistic t1
               inner join coz_server3_cate_dealstatus_statistic_detail t2 on t1.guid = t2.statistic_guid
      where t1.del_flag = '0'
        and t2.del_flag = '0'
        and t1.dstatus = 312
        and t1.sd_path_guid = '{sdPathGuid}'
        and (t1.demand_user_id = '{demandOrSupplyUserId}' or t2.supply_user_id = '{demandOrSupplyUserId}' or
             '{demandOrSupplyUserId}' = '')
        and t1.sd_path_guid = '{sdPathGuid}'
        and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})) t
where (catDealStatus <= 221 and '{mode}' = '2')
   or (catDealStatus >= 311 and '{mode}' = '3')
order by catDealStatus;