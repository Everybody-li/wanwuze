-- ##Title insertDeReqPriceAndPlateT
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 需求-新增需求供方
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input supplierGuid char[36] NOTNULL;供方品类guid，必填
-- ##input modelGuid string[36] NULL;供方品类型号guid，非必填
-- ##input requestSupplyGuid char[36] NOTNULL;需求供方guid，必填
-- ##input userId char[36] NOTNULL;供方用户guid，必填
-- ##input userName string[30] NOTNULL;供方用户姓名，必填
-- ##input userPhone string[30] NOTNULL;供方用户姓名，必填
-- ##input priceStatus char[1] NOTNULL;报价状态，必填
-- ##input priceTime string[19] NOTNULL;接单语音消息提醒中间件推送时间，必填
-- ##input deReadFlag char[1] NOTNULL;报价状态，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_demand_request_supply(guid, request_guid, supplier_guid, model_guid, user_name, user_phone,
                                      price_status, price_time, de_read_flag, del_flag, create_by, create_time,
                                      update_by, update_time)
select '{requestSupplyGuid}' as guid
     , '{requestGuid}'       as request_guid
     , '{supplierGuid}'      as supplier_guid
     , '{modelGuid}'         as model_guid
     , '{userName}'          as user_name
     , '{userPhone}'         as user_phone
     , '{priceStatus}'       as price_status
     , '{priceTime}'         as price_time
     , '{deReadFlag}'        as de_read_flag
     , '0'                   as del_flag
     , '{createBy}'          as create_by
     , now()                 as create_time
     , '{createBy}'          as update_by
     , now()                 as update_time;

set @supplySysUserId = '';

select user_guid
into @supplySysUserId
from coz_server3_sys_user_dj_bind
where binded_user_id = '{userId}'
  and user_type = '2' limit 1;

# 保存供方的对接专员
insert into coz_demand_request_supply_server3(guid, request_supply_guid, sys_user_guid)
    value (uuid(), '{requestSupplyGuid}', @supplySysUserId);
