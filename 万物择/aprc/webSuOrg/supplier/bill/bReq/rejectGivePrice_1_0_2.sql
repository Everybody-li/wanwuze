-- ##Title web-供应机构-拒绝报价
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 后端修改表，将报价状态改为拒绝报价，表数据的报价状态为未报价时修改，否则不做任何处理
-- ##CallType[ExSql]

-- ##input requestSupplyGuid char[36] NOTNULL;需求guid，必填
-- ##input refusePriceReason string[300] NOTNULL;拒绝报价理由，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_demand_request_supply
set price_status='2'
  , refuse_price_reason='{refusePriceReason}'
  , price_time=now()
  , update_by='{curUserId}'
  , update_time=now()
where guid = '{requestSupplyGuid}'
  and price_status = '1'
;

# 品类交易状态逻辑---开始---
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @demandUserGuid = '';
set @requestGuid = '';
set @supplyUserName = '';

select t1.guid, t1.user_id, t1.category_mode,t2.user_name
into @requestGuid,@demandUserGuid,@catMode,@supplyUserName
from coz_demand_request t1
         inner join coz_demand_request_supply t2 on t1.guid = t2.request_guid
where t2.guid = '{requestSupplyGuid}';

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
where binded_user_id = '{curUserId}'
  and user_type = '2';

# 审批模式:更新品类交易状态-供应拒绝报价--仅审批模式下处理该状态
update coz_server3_cate_dealstatus_statistic
set biz_guid            = '{requestSupplyGuid}'
  , dstatus             = 315
  , update_time=now()
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
  , supply_user_id='{curUserId}'
  , supply_user_name=@supplyUserName
where biz_guid = @requestGuid
  and @catMode = 3;
# 品类交易状态逻辑---结束---


