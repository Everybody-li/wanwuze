-- ##Title 订单退货的退款业务处理
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 订单退货的退款业务处理
-- ##CallType[ExSql]

-- ##input orderRefundGuid char[36] NOTNULL;订单退款guid,必填
-- ##input refundFee int[>=0] NULL;订单退款金额,非必填
-- ##input refundPayNo string[50] NULL;订单支付单号,非必填
-- ##input refundPayFlag char[1] NOTNULL;退款支付标志：0-未支付，1-已支付,2-支付中,3-支付失败,必填
-- ##input refundPayReadFlag char[1] NULL;退款阅读标志：0-无需阅读，1-未读，2-已读

update coz_order_refund
set refund_pay_flag='{refundPayFlag}'
,refund_pay_time=now()
,refund_pay_read_flag='1'
,confirm_refund_pay_time=now()
,confirm_refund_pay_prove='金额原路退回，自动确认'
,confirm_refund_pay_flag='1'
,confirm_refund_pay_remark='系统原路退回'
{dynamic:refundFee[,refund_fee={refundFee}]/dynamic}
{dynamic:refundPayNo[,refund_pay_no='{refundPayNo}']/dynamic}
{dynamic:refundPayReadFlag[,refund_pay_read_flag='{refundPayReadFlag}']/dynamic}
where guid='{orderRefundGuid}'
;



# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --
#定义需方对接专员用户id
set @demandSysUserGuid = '';
#定义供方对接专员用户id
set @supplySysUserGuid = '';
#定义需方用户id
set @demandUserGuid = '';
#定义供方对接用户id
set @supplyUserGuid = '';
# 定义品类模式
set @catMode = '';
# 定义品类状态仲裁guid
set @judgeGuid = '';

select t1.demand_user_id, t1.supply_user_id,t3.category_mode,t4.guid
into @demandUserGuid,@supplyUserGuid,@catMode,@judgeGuid
from coz_order t1
         inner join coz_order_refund t2 on t1.guid = t2.order_guid
         inner join coz_demand_request t3 on t1.request_guid = t3.guid
         inner join coz_order_judge t4 on t2.guid = t4.biz_guid
where t2.guid = '{orderRefundGuid}';

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

# 交易模式:更新品类交易状态为需方/供方取消订单-退款到账,交易模式有仲裁
update coz_server3_cate_dealstatus_statistic
set update_time         = now()
  , dstatus             = 221
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = @judgeGuid and @catMode =2
;
# 审批模式:更新品类交易状态为供方取消订单-退款到账,审批模式无仲裁,无退货
# update coz_server3_cate_dealstatus_statistic
# set update_time         = now()
#   , dstatus             = 321
#   , demand_sys_user_guid=@demandSysUserGuid
#   , supply_sys_user_guid=@supplySysUserGuid
# where biz_guid = '{orderRefundGuid}' and @catMode =3
# ;
# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --