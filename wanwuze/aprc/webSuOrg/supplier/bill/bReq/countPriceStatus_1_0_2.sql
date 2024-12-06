-- ##Title app-供应-按单-品类按单报价各状态数量统计_1_0_2
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-按单-品类按单报价各状态数量统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id
-- ##input supplierGuid char[36] NOTNULL;供方品类表guid
-- ##input sdPathGuid string[36] NOTNULL;采购供应路径guid


select t1.priceStatus, ifnull(t2.count, 0) as count
from
    (
        select '1' as priceStatus
        union all
        select '2' as priceStatus
        union all
        select '3' as priceStatus
    )           t1
    left join (

                  select count(1) as `count`, a.price_status as priceStatus
                  from
                      coz_demand_request_supply     a
                      inner join coz_demand_request b on a.request_guid = b.guid
                  where
                        a.supplier_guid = '{supplierGuid}'
                    and b.sd_path_guid = '{sdPathGuid}'
                    and a.del_flag = '0'
                    and b.cancel_flag = '0'
                    and b.done_flag = '0'
                  group by a.price_status
              ) t2 on t1.priceStatus = t2.priceStatus
;

