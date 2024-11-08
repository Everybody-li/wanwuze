-- ##Title 修改品类对称标志
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供方-添加品类
-- ##CallType[ExSql]

-- ##input orderGuid string[200] NOTNULL;订单guid，必填
-- ##input payNo string[50] NOTNULL;支付流水号，必填
-- ##input merchantNo string[50] NOTNULL;第三方支付商户订单号，必填
-- ##input userPayExtra string[2000] NOTNULL;用户支付账号信息，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @requestPriceGuid = '';
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @supplyUserGuid = '';
set @supplyUserName = '';
set @demandUserGuid = '';
set @requestGuid = '';

# 查询审批模式下上一状态业务guid,需方用户id
select t1.request_price_guid, t1.request_guid, demand_user_id, supply_user_id, t3.user_name
into @requestPriceGuid,@requestGuid,@demandUserGuid,@supplyUserGuid,@supplyUserName
from coz_order t1
         inner join coz_demand_request_price t2 on t1.request_price_guid = t2.guid
         inner join coz_demand_request_supply t3 on t2.request_supply_guid = t3.guid
where t1.guid = '{orderGuid}'
limit 1;

# 查询需方用户的对接专员
select user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = @demandUserGuid
  and user_type = '1';

# 查询供方用户的对接专员
select user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = @supplyUserGuid
  and user_type = '2';

# 交易模式:更新品类交易状态
update coz_server3_cate_dealstatus_statistic
set biz_guid             = '{orderGuid}'
  , update_time=now()
  , dstatus              = 214
  , supply_user_id       = @supplyUserGuid
  , supply_user_name     = @supplyUserName
  , demand_sys_user_guid = @demandSysUserGuid
  , supply_sys_user_guid = @supplySysUserGuid
where biz_guid = @requestGuid
  and dstatus = 211;

# 审批模式:更新品类交易状态
update coz_server3_cate_dealstatus_statistic
set biz_guid             = '{orderGuid}'
  , update_time=now()
  , dstatus              = 317
  , supply_user_id       = @supplyUserGuid
  , supply_user_name     = @supplyUserName
  , demand_sys_user_guid = @demandSysUserGuid
  , supply_sys_user_guid = @supplySysUserGuid
where biz_guid = @requestPriceGuid
  and dstatus = 316;

# 更新订单支付状态
update coz_order
set pay_status= '2'
  , pay_time=now()
  , pay_no='{payNo}'
  , merchant_no='{merchantNo}'
  , user_pay_extra='{userPayExtra}'
  , update_by='{curUserId}'
  , update_time=now()
where guid = '{orderGuid}';
