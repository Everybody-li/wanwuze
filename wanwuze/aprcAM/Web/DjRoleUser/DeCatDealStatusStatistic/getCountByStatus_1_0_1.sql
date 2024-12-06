-- 目录:aprcAM\Web\DjRoleUser\DeCatDealStatusStatistic\getCountByStatus_1_0_1
-- ##Title web-对接专员操作管理-购方对接管理-购方用户采购管理-管理采购成果管理-审批模式/交易模式-查询渠道需求提交数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 查询 目标所属类型的品类采购交易状态下具体数量
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,xxxx,每个状态用到哪些表,参考对应状态的列表数据接口
-- ##CallType[QueryData]

-- ##input catDealStatus int[>0] NOTNULL;211;品类节点状态：交易模式：211-采购需求提交，212-供方供应报价，213-需方删除需求，214-需求采购支付，215-供应取消订单，216-需方取消订单，217-供方供应完成，218-需方申请退货，219-订单交易仲裁，220-订单验收通过，221-退款退货订单。审批模式：311-渠道需求提交，312-办理申请点击，313-办理申请提交，314-需方删除申请，315-供应拒绝报价，316-供方供应报价，317-需求采购支付，318-供应取消订单，319-供方办理通知，320-供方供应完成，321-退款退货订单，322-订单验收通过
-- ##input categoryName string[500] NULL;品类名称,模糊搜索
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称,4-采购供应路径
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid或采购供应路径guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input demandOrSupplyUserId char[36] NULL;需方用户id或供方用户id

-- ##output totalNum int[>=0] 0;数量

select
    case {catDealStatus}
        when 211 then
            (
                select count(distinct t1.guid) as totalNum
                from
                    coz_server3_cate_dealstatus_statistic        t1
                    inner join coz_demand_request                dr on t1.biz_guid = dr.guid
                    left join  coz_demand_request_supply         drs on dr.guid = drs.request_guid
                    left join  coz_demand_request_supply_server3 drss3 on drs.guid = drss3.request_supply_guid
                    left join  coz_category_supplier             cs on drs.supplier_guid = cs.guid
                where
                      t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and dr.del_flag = '0'
                  and dr.cancel_flag = '0'
                  and dr.done_flag = '0'
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and (dr.category_name like '%{categoryName}%' or '{categoryName}' = '')
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or cs.user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and (('{targetUserType}' = '1' and t1.demand_sys_user_guid = '{targetUserId}') or
                       ('{targetUserType}' = '2' and drss3.sys_user_guid = '{targetUserId}') or
                       ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}') or
                       ('{targetUserType}' = '4' and t1.sd_path_guid = '{targetUserId}'))
                  and not exists(select 1
                                 from
                                     coz_demand_request_supply
                                 where dr.guid = request_guid and price_status in ('2', '3'))
            )
            when 212 then
               (select count(distinct t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_demand_request t2 on t1.biz_guid = t2.guid
                         inner join coz_demand_request_supply drs on t2.guid = drs.request_guid
                         left join coz_demand_request_supply_server3 drss3 on drs.guid = drss3.request_supply_guid
                         left join coz_category_supplier cs on drs.supplier_guid = cs.guid
                where  t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t2.cancel_flag = '0'
                  and t2.done_flag = '0'
                  and drs.price_status = '3'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or cs.user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and (('{targetUserType}' = '1' and t1.demand_sys_user_guid = '{targetUserId}') or
                       ('{targetUserType}' = '2' and drss3.sys_user_guid = '{targetUserId}') or
                       ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}') or
                       ('{targetUserType}' = '4' and t1.sd_path_guid = '{targetUserId}')
                    ))

           when 213 then
               (select count(distinct t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_demand_request dr on t1.biz_guid = dr.guid
                         left join coz_demand_request_supply drs on dr.guid = drs.request_guid
                         left join coz_demand_request_supply_server3 drss3 on drs.guid = drss3.request_supply_guid
                         left join coz_category_supplier cs on drs.supplier_guid = cs.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and dr.del_flag = '0'
                  and dr.cancel_flag = '1'
                  and dr.done_flag = '0'
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and (dr.category_name like '%{categoryName}%' or '{categoryName}' = '')
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or cs.user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and (('{targetUserType}' = '1' and t1.demand_sys_user_guid = '{targetUserId}') or
                       ('{targetUserType}' = '2' and drss3.sys_user_guid = '{targetUserId}') or
                       ('{targetUserType}' = '3' and t1.category_guid = '{targetUserId}') or
                       ('{targetUserType}' = '4' and t1.sd_path_guid = '{targetUserId}')))
           when 214 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order corder on t1.biz_guid = corder.guid
                         left join coz_order_judge cojudge on corder.guid = cojudge.order_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and corder.pay_status = '2'
                  and corder.accept_status = '0'
                  and corder.supply_done_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and cojudge.guid is null )
           when 215 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order_judge t2 on t1.biz_guid = t2.biz_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.biz_type = '1'
                  and t2.result = '0')
           when 216 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order_judge t2 on t1.biz_guid = t2.biz_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.biz_type = '1'
                  and t2.result = '0')
           when 217 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order t2 on t1.biz_guid = t2.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.pay_status = '2'
                  and t2.supply_done_flag = '1')
           when 218 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order_judge t2 on t1.biz_guid = t2.biz_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.biz_type = '2'
                  and t2.result = '0')
           when 219 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order_judge cojudge on t1.biz_guid = cojudge.guid
                         left join coz_order_judge_fee cojudgeFee1
                                   on cojudge.guid = cojudgeFee1.judge_guid and cojudgeFee1.fee_type = 1
                         left join coz_order_judge_fee cojudgeFee2
                                   on cojudge.guid = cojudgeFee2.judge_guid and cojudgeFee2.fee_type = 2
                         inner join coz_order corder on corder.guid = cojudge.order_guid
                         inner join coz_demand_request dr on corder.request_guid = dr.guid
                where t1.del_flag = '0'
                  and dr.del_flag = '0'
                  and dr.del_flag = '0'
                  and cojudge.del_flag = '0'
                  and t1.dstatus = '219'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and cojudge.result <> '0'
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and (cojudge.result in ('1', '2', '4') and cojudgeFee1.pay_status = '0' or
                       cojudgeFee2.pay_status = '0')
                )
           when 220 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order t2 on t1.biz_guid = t2.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.pay_status = '2'
                  and t2.accept_status = '1')
           when 221 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order_judge t2 on t1.biz_guid = t2.guid
                         left join coz_order_cancel t3 on t2.biz_guid = t3.guid
                         left join coz_order_refund t4 on t2.biz_guid = t4.guid
                where t1.dstatus = {catDealStatus}
                    and t1.del_flag = '0'
                    and t2.del_flag = '0'
                    and t3.del_flag = '0'
                    and t4.del_flag = '0'
                    and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                         '{demandOrSupplyUserId}' = '')
                    and t1.sd_path_guid = '{sdPathGuid}'
                    and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                    and t2.result in ('1', '2', '4')
                   or (t3.guid is not null and t3.refund_pay_status = '2')
                   or (t4.guid is not null and t3.refund_pay_status = '2'))
           when 311 then
               (select count(1) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_aprom_pre_demand_request t2
                                    on t1.biz_guid = t2.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file}))
           when 312 then
               (select count(t2.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_server3_cate_dealstatus_statistic_detail t2 on t1.guid = t2.statistic_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t2.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.del_flag = '0')
           when 313 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_demand_request t2 on t1.biz_guid = t2.guid
                         inner join coz_demand_request_supply t3 on t2.guid = t3.request_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t3.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.cancel_flag = '0'
                  and t2.done_flag = '0'
                  and t3.price_status = '1')
           when 314 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_demand_request t2 on t1.biz_guid = t2.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.cancel_flag = '1')
           when 315 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_demand_request_supply t2 on t1.biz_guid = t2.guid
                         inner join coz_demand_request t3 on t2.request_guid = t3.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t3.del_flag = '0'
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t3.cancel_flag = '0'
                  and t3.done_flag = '0'
                  and t2.price_status = '2')
           when 316 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_demand_request_price t2 on t1.biz_guid = t2.guid
                         inner join coz_demand_request t3 on t2.request_guid = t3.guid
                         inner join coz_demand_request_supply t4 on t2.request_supply_guid = t4.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t3.del_flag = '0'
                  and t4.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t3.cancel_flag = '0'
                  and t3.done_flag = '0'
                  and t4.price_status = '3')
           when 317 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order t2 on t1.biz_guid = t2.guid
                         left join coz_order_cancel t3 on t2.guid = t3.order_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.pay_status = '2'
                  and t2.supply_done_flag = '0'
                  and t2.accept_status = '0'
                  and t3.guid is null)
           when 318 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order_cancel t2 on t1.biz_guid = t2.guid
                         inner join coz_order t3 on t2.order_guid = t3.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t3.del_flag = '0'
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.supply_done_flag = '0'
                  and t2.cancel_object = '2'
                  and t3.pay_status = '2')
           when 319 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order t2 on t1.biz_guid = t2.guid
                         inner join coz_order_am_notice t3 on t2.guid = t3.order_guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t3.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.pay_status = '2'
                  and t2.supply_done_flag = '0')
           when 320 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order t2 on t1.biz_guid = t2.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.pay_status = '2'
                  and t2.supply_done_flag = '1')
           when 321 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order_cancel t2 on t1.biz_guid = t2.guid
                         inner join coz_order t3 on t2.order_guid = t3.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and t3.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.cancel_object = '2'
                  and (t2.refund_pay_status = '2'
                    or t2.refund_pay_status = '3'))
           when 322 then
               (select count(t1.biz_guid) as totalNum
                from coz_server3_cate_dealstatus_statistic t1
                         inner join coz_order t2 on t1.biz_guid = t2.guid
                where t1.dstatus = {catDealStatus}
                  and t1.del_flag = '0'
                  and t2.del_flag = '0'
                  and (t1.demand_user_id = '{demandOrSupplyUserId}' or t1.supply_user_id = '{demandOrSupplyUserId}' or
                       '{demandOrSupplyUserId}' = '')
                  and t1.sd_path_guid = '{sdPathGuid}'
                  and ({file[aprcAM/Web/DjRoleUser/DeCatDealStatusStatistic/getStatusComSerachCondi_1_0_1.sql]/file})
                  and t2.pay_status = '2'
                  and t2.accept_status = '1')
           end as totalNum;