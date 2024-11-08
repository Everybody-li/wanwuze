-- ##Title web-查询品类采购进展-查看需求进展数量详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类采购进展-查看需求进展数量详情
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

select 
(select count(1) from coz_demand_request t1 where t1.category_guid='{categoryGuid}' and t1.del_flag='0' and (exists(select 1 from coz_demand_request_supply where del_flag='0' and request_guid=t1.guid and price_status='1') or not exists(select 1 from coz_demand_request_supply where del_flag='0' and request_guid=t1.guid))) as NoPriceNum
,(select count(1) from coz_demand_request t1 where t1.category_guid='{categoryGuid}' and t1.del_flag='0' and t1.done_flag='0' and exists(select 1 from coz_demand_request_supply where del_flag='0' and request_guid=t1.guid and price_status='3')) as NoPayNum
,(select count(1) from coz_demand_request a inner join coz_order b on b.request_guid=a.guid where a.category_guid='{categoryGuid}' and a.del_flag='0' and b.del_flag='0' and b.supply_done_flag='0' )  as NoSupplyNum
,(select count(1) from coz_demand_request a inner join coz_order b on b.request_guid=a.guid where a.category_guid='{categoryGuid}' and a.del_flag='0' and b.del_flag='0' and b.supply_done_flag='1' and b.accept_status='0')  as NoacceptNum
,(select count(1) from coz_demand_request a inner join coz_order b on b.request_guid=a.guid inner join coz_order_judge c on b.guid=c.order_guid where a.category_guid='{categoryGuid}' and a.del_flag='0' and b.del_flag='0' and b.accept_status='0' and (c.result='0'or c.result='1' or c.result='4'))  as returnNum
,(select count(1) from coz_demand_request a inner join coz_order b on b.request_guid=a.guid where a.category_guid='{categoryGuid}' and a.del_flag='0' and b.del_flag='0' and b.accept_status='1')  as acceptNum

