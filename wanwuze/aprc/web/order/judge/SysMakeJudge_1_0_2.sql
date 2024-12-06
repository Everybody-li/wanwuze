-- ##Title web-非系统名义裁决意见批复
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-非系统名义裁决意见批复
-- ##CallType[QueryData]

-- ##input judgeGuid char[36] NOTNULL;裁决guid，必填
-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input feeNo1 string[50] NOTNULL;仲裁账单类型1编号，必填
-- ##input feeNo2 string[50] NOTNULL;仲裁账单类型2编号，必填
-- ##input reason string[50] NOTNULL;裁决理由，必填
-- ##input result string[50] NOTNULL;裁决结果（1：需方违约，支持退款，2：供方违约，支持退款，3：交易正常，维持交易），必填
-- ##input thirdReports string[600] NULL;第三方报告图片，多个逗号分隔，非必填
-- ##input disobeyFee int[>=0] NULL;违约费违约费用，必填，没有就是0
-- ##input disobeyFeeRemark string[50] NULL;违约费用说明，非必填
-- ##input obeyFee int[>=0] NULL;赔偿金，必填，没有就是0
-- ##input obeyFeeRemark string[50] NULL;赔偿金说明，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @disobeyUserId = (select case
                                 when ('{result}' = '1') then demand_user_id
                                 when ('{result}' = '2') then supply_user_id
                                 else '0' end
                      from coz_order
                      where guid = '{orderGuid}')
;
set @obeyUserId = (select case
                              when ('{result}' = '1') then supply_user_id
                              when ('{result}' = '2') then demand_user_id
                              else '0' end
                   from coz_order
                   where guid = '{orderGuid}')
;
set @disobeyObject = (select case when ('{result}' = '1') then '1' when ('{result}' = '2') then '2' else '0' end
                      from coz_order
                      where guid = '{orderGuid}')
;
set @judgefeeguid1 = uuid()
;
set @judgefeeguid2 = uuid()
;

set @flag1 = (select case
                         when (exists(select 1
                                      from coz_order_judge
                                      where order_guid = '{orderGuid}'
                                        and biz_type = '2'
                                        and del_flag = '0') and
                               ('{result}' = '1')) then '0'
                         else '1' end)
;
set @cancelObject = (select t4.cancel_object
                     from coz_order_judge t2
                              inner join coz_order_cancel t4 on t2.order_guid = t4.order_guid
                     where t2.del_flag = '0'
                       and t4.del_flag = '0'
                       and t2.order_guid = '{orderGuid}'
                       and t2.biz_type = '1')
;
set @flag2 = (select case
                         when (@cancelObject = '1' and '{result}' <> '1') then '2'
                         when (@cancelObject = '2' and '{result}' <> '2') then '3'
                         else '1' end)
;
update coz_order_judge
set reason='{reason}'
  , result='{result}'
  , third_reports='{thirdReports}'
  , disobey_fee='{disobeyFee}'
  , disobey_fee_remark='{disobeyFeeRemark}'
  , obey_fee='{obeyFee}'
  , obey_fee_remark='{obeyFeeRemark}'
  , disobey_user_id=@disobeyUserId
  , obey_user_id=@obeyUserId
  , disobey_object=@disobeyObject
  , result_time=now()
  , update_by='{curUserId}'
  , update_time=now()
where guid = '{judgeGuid}'
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_order_judge_fee(guid, judge_guid, fee_no, fee_type, fee, del_flag, create_by, create_time, update_by,
                                update_time)
select @judgefeeguid1
     , '{judgeGuid}'
     , '{feeNo1}'
     , 1
     , {disobeyFee}
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order_judge t
where guid = '{judgeGuid}'
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_order_judge_fee(guid, judge_guid, fee_no, fee_type, fee, del_flag, create_by, create_time, update_by,
                                update_time)
select @judgefeeguid2
     , '{judgeGuid}'
     , '{feeNo2}'
     , 2
     , {obeyFee}
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order_judge t
where guid = '{judgeGuid}'
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , '{orderGuid}'
     , ifnull(
        (select status from coz_order_operation_log where order_guid = '{orderGuid}' order by create_time desc limit 1),
        '0')
     , '3'
     , '0'
     , ''
     , '{curUserId}'
     , now()
from coz_order_judge t
where guid = '{judgeGuid}'
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_order_notice(guid, cat_tree_code, user_id, user_type, order_guid, type, biz_guid, del_flag, create_by,
                             create_time, update_by, update_time)
select uuid()
     , case when ('{result}' = '1') then 'demand' else 'supply' end
     , disobey_user_id
     , case when ('{result}' = '1') then '1' else '2' end
     , order_guid
     , 2
     , @judgefeeguid1
     , 0
     , '-1'
     , now()
     , '{curUserId}'
     , now()
from coz_order_judge t
where guid = '{judgeGuid}'
  and '{result}' <> '3'
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_order_notice(guid, cat_tree_code, user_id, user_type, order_guid, type, biz_guid, del_flag, create_by,
                             create_time, update_by, update_time)
select uuid()
     , case when ('{result}' = '1') then 'demand' else 'supply' end
     , obey_user_id
     , case when ('{result}' = '1') then '1' else '2' end
     , order_guid
     , 3
     , @judgefeeguid2
     , 0
     , '-1'
     , now()
     , '{curUserId}'
     , now()
from coz_order_judge t
where guid = '{judgeGuid}'
  and '{result}' <> '3'
  and @flag1 = '1'
  and @flag2 = '1'
;
insert into coz_order_notice(guid, cat_tree_code, user_id, user_type, order_guid, type, biz_guid, del_flag, create_by,
                             create_time, update_by, update_time)
select uuid()
     , case when ('{result}' = '1') then 'demand' else 'supply' end
     , t1.demand_user_id
     , case when ('{result}' = '1') then '1' else '2' end
     , t.order_guid
     , 3
     , t.biz_guid
     , 0
     , '-1'
     , now()
     , '-1'
     , now()
from coz_order_judge t
         left join
     coz_order t1
     on t.order_guid = t1.guid
where t.guid = '{judgeGuid}'
  and '{result}' <> '3'
  and @flag1 = '1'
  and @flag2 = '1'
;

# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @demandUserGuid = '';
set @supplyUserGuid = '';
set @statisticBizGuidMode2 = '';

# 品类交易状态,上一状态业务guid,订单取消guid或订单退货guid
select biz_guid
into @statisticBizGuidMode2
from coz_order_judge
where guid = '{judgeGuid}';

# 品类订单的需方和供方用户id
select demand_user_id, supply_user_id
into @demandUserGuid,@supplyUserGuid
from coz_order
where guid = '{orderGuid}';

# 查询需方用户的对接专员
select t2.user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_sys_user_dj_bind t2
where binded_user_id = @demandUserGuid
  and t2.user_type = '1';

# 查询供方用户的对接专员
select t2.user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind t2
where binded_user_id = @supplyUserGuid
  and t2.user_type = '2';

# 交易模式:更新品类交易状态为订单仲裁交易--父订单,仅交易模式有该状态
update coz_server3_cate_dealstatus_statistic
set biz_guid            = '{judgeGuid}'
  , update_time=now()
  , dstatus             = 219
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = @statisticBizGuidMode2
  and @flag1 = '1'
  and @flag2 = '1'
;
# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --

select case when (@flag1 = '1' and @flag2 = '1') then '1' else '0' end as okFlag
     , case
           when (@flag1 = '0') then '当前订单为需方申请退货，裁决结果请选择【供方违约，支持退款】或【交易正常，维持交易】'
           when (@flag2 = '2') then '当前订单为需方取消订单，裁决结果请选择【需方违约，支持退款】'
           when (@flag2 = '3') then '当前订单为供方取消订单，裁决结果请选择【供方违约，支持退款】'
           else '操作成功' end                                         as msg