-- ##Title app-采购-查询已提的需求列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-20
-- ##Describe app-采购-查询已提的需求列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output categoryGuid string[36] 品类名称guid;
-- ##output categoryName string[50] 品类名称;
-- ##output categoryImg string[50] 品类图片;
-- ##output categoryAlias string[50] 品类名称别名，多个逗号分隔;
-- ##output totalSupplyNum int[>=0] 需求供方数量(t2.的已报价的供方数量);
-- ##output unReadPriceNum int[>=0] 需方未读的已报价的供方数量，无供方的返回0;
-- ##output reqCreateTime string[19] 提出需求日期（格式：0000-00-00 00:00）;
-- ##output sdPathGuid char[36] ;采购供应路径关联guid
-- ##output sdPathAllName string[100] ;采购供应路径全节点名称
-- ##output requestGuid string[36] 需求guid;需求guid
-- ##output requestPriceGuid char[36] 订单需求供方报价guid;
-- ##output orgName string[50] ;供应供方-机构名称
-- ##output QueryRefuPriceBtnFlag int[>=0] 查看拒绝报价事由按钮高亮标志：0-置灰，1_高亮;

select t.sd_path_guid                       as sdPathGuid
     , t.sd_path_all_name                   as sdPathAllName
     , t.guid                               as requestGuid
     , t.status0_read_flag
     , t.category_guid                      as categoryGuid
     , t.category_name                      as categoryName
     , t.category_img                       as categoryImg
     , t.category_alias                     as categoryAlias
     , t.status0_read_flag                  as status0ReadFlag
     , (select count(1)
        from coz_demand_request_supply
        where price_status = '3'
          and request_guid = t.guid)        as totalSupplyNum
     , (select count(1)
        from coz_demand_request_supply
        where de_read_flag = '1'
          and price_status = '3'
          and request_guid = t.guid)        as unReadPriceNum
     , left(t.create_time, 19)              as reqCreateTime
     , (select guid
        from coz_demand_request_price
        where request_guid = t.guid
          and del_flag = '0'
        limit 1)                            as requestPriceGuid
     , IF(drs.price_status = '2', '1', '0') as QueryRefuPriceBtnFlag
     , concat(drs.user_name,'(',drs.model_name,')')                        as orgName
from coz_demand_request t
         inner join coz_demand_request_supply drs on drs.request_guid=t.guid
where t.sd_path_guid = '{sdPathGuid}'
  and t.del_flag = '0'
  and t.done_flag = '0'
  and (t.status0_read_flag = '0' or t.status0_read_flag = '1')
  and t.user_id = '{curUserId}'
  and t.cancel_flag = '0'
  and (parent_guid = '' or parent_guid is null)
  and drs.del_flag = '0'
  and t.category_mode=3
order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};