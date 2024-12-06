-- ##Title app-采购-取消需求
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-采购-取消需求
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input curUserId string[36] NOTNULL;需方用户id，必填

# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @catMode ={url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\CatDealStatus\getCatModeByReqGuid_1_0_1&requestGuid={requestGuid}&DBC=w_a]/url};

# 查询需方用户的对接专员
select t2.user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_sys_user_dj_bind t2
     on t1.demand_user_id = t2.binded_user_id
where t1.biz_guid = '{requestGuid}'
  and t2.user_type = '1'
  and t1.del_flag = '0';

# 查询供方用户的对接专员
select t2.user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_sys_user_dj_bind t2
     on t1.supply_user_id = t2.binded_user_id
where t1.biz_guid = '{requestGuid}'
  and t2.user_type = '2'
  and t1.del_flag = '0';

# 交易模式:更新品类交易状态为需方删除需求
update coz_server3_cate_dealstatus_statistic
set dstatus             = 213
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
  , update_time=now()
where biz_guid = '{requestGuid}'
  and @catMode = 2;


# 审批模式:更新品类交易状态为需方删除需求,已报价或拒绝报价的需求(交易状态表记录的供方guid),也可能被删,
update coz_server3_cate_dealstatus_statistic
set dstatus             = 314
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
  , update_time=now()
where (biz_guid = '{requestGuid}'
   or biz_guid =
      (select guid from coz_demand_request_supply where request_guid = '{requestGuid}' and price_status = '2')
   or biz_guid =
      (select guid from coz_demand_request_price where request_guid = '{requestGuid}'))
    and @catMode = 3
;
# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --


# 取消需求业务逻辑
update coz_demand_request
set cancel_flag='1'
  , cancel_xjsuser_read_flag='1'
  , cancel_time=now()
  , update_by='{curUserId}'
  , update_time=now()
where (guid = '{requestGuid}' or parent_guid = '{requestGuid}')
  and done_flag = '0'
  and (status0_read_flag = '0')
;

