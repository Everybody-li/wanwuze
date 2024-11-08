-- ##Title app-供应-确认处理完成
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-确认处理完成
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填


set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @demandUserGuid = '';
set @catMode = {url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Com\Utils\CatDealStatus\getCatModeByOrderGuid_1_0_1&orderGuid={orderGuid}&DBC=w_a]/url};

select demand_user_id
into @demandUserGuid
from coz_order
where guid = '{orderGuid}';

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

# 交易模式:更新品类交易状态-供方供应完成
update coz_server3_cate_dealstatus_statistic
set dstatus             = 217
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid =  '{orderGuid}' and @catMode = 2;

# 审批模式:更新品类交易状态-供方供应完成
update coz_server3_cate_dealstatus_statistic
set dstatus             = 320
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid =  '{orderGuid}' and @catMode = 3;


insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , '{orderGuid}'
     , ifnull(
        (select status from coz_order_operation_log where order_guid = '{orderGuid}' order by create_time desc limit 1),
        '0')
     , '4'
     , '2'
     , ''
     , '{curUserId}'
     , now()
;
update coz_order
set supply_done_flag='1'
  , supply_done_time=now()
  , accept_deadline=DATE_ADD(now(), interval deadline_day HOUR)
  , biz_rule_type3='c9b59b33-7374-11ec-a478-0242ac120003'
  , update_by='{curUserId}'
  , update_time=now()
  , accept_cal_remark=concat(now(), '供方验收通过时品类验收期限为', deadline_day, '小时')
where guid = '{orderGuid}'
  and not exists(select 1 from coz_order_judge where order_guid = '{orderGuid}' and del_flag = '0')
;