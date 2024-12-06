-- ##Title app-供应-按单-品类按单报价各状态数量统计
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-按单-品类按单报价各状态数量统计
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input supplierGuid char[36] NOTNULL;供方品类表guid，必填


select '1'                       as priceStatus,
       (select count(1)
        from coz_demand_request_supply a
                 inner join coz_demand_request b on a.request_guid = b.guid
        where a.supplier_guid = '{supplierGuid}'
          and a.price_status = '1'
          and a.del_flag = '0'
          and b.cancel_flag = '0'
          and b.done_flag = '0') as `count`
union all
select '2'                       as priceStatus,
       (select count(1)
        from coz_demand_request_supply a
                 inner join coz_demand_request b on a.request_guid = b.guid
        where a.supplier_guid = '{supplierGuid}'
          and a.price_status = '2'
          and a.del_flag = '0'
          and b.cancel_flag = '0'
          and b.done_flag = '0') as `count`
union all
select '3'                       as priceStatus,
       (select count(1)
        from coz_demand_request_supply a
                 inner join coz_demand_request b on a.request_guid = b.guid
               where a.supplier_guid = '{supplierGuid}'
          and a.price_status = '3'
          and a.del_flag = '0'
          and b.cancel_flag = '0'
          and b.done_flag = '0') as `count`