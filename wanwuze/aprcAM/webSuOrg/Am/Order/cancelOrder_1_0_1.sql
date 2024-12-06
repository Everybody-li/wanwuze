-- ##Title web机构端-审批模式-切换合作项目-订单供应管理-成果交接管理-取消订单
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 修改
-- ##Describe 前置条件：订单供方未供应且订单未取消，则可以取消订单，否则不可以并返回提示：“当前订单不可取消，请检查是否已经供应完成或已取消”
-- ##Describe 数据逻辑：新增t2。t3
-- ##Describe 新增t2：取消对象=供方， 品类取消订单规则guid：从t5获取，t5.type=1，退货裁决规则guid：从t5获取，t5.type=21，refund_fee=t1.pay_fee，取消订单用户id=当前用户id，其余字段默认值
-- ##Describe 新增t3：上一状态查coz_order_operation_log最近记录的值，无则填0，当前状态=2 供方取消订单
-- ##Describe 表名： coz_order t1,coz_order_cancel t2,coz_order_operation_log t3
-- ##Describe <p style="color:red">前端：当前接口返回成功后，再调用一个代理接口：aprc_webSuorg_01_1_0_1</p>
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid
-- ##input reason string[100] NOTNULL;取消订单理由
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 操作结果：0-失败，1-成功;
-- ##output msg enum[0,1] 1;操作提示信息

set @Flag1 = (select case when (accept_status = 0 and supply_done_flag = 0) then '1' else '0' end
              from coz_order
              where guid = '{orderGuid}')
;
set @Flag2 = (select case
                         when not exists(select 1
                                         from coz_order_cancel
                                         where order_guid = '{orderGuid}'
                                           and cancel_user_id = '{curUserId}') then '1'
                         else '0' end)
;
set @parentguid = (select parent_guid
                   from coz_order
                   where guid = '{orderGuid}')
;
set @cancelorderguid = uuid()
;
insert into coz_order_cancel(guid, order_guid, cancel_user_id, cancel_object, reason, biz_rule_type1, biz_rule_type21,
                             refund_pay_read_flag, refund_fee, refund_pay_status, del_flag, create_by, create_time,
                             update_by, update_time)
select @cancelorderguid
     , t.guid
     , '{curUserId}'
     , '2'
     , '{reason}'
     , 'c9b596d4-7374-11ec-a478-0242ac120003'
     , 'c9b59b73-7374-11ec-a478-0242ac120003'
     , '0'
     , t.pay_fee
     , '0'
     , '0'
     , '{curUserId}'
     , now()
     , '{curUserId}'
     , now()
from coz_order t
where (t.guid = '{orderGuid}')
  and @Flag1 = '1'
  and @Flag2 = '1'
;
insert into coz_order_operation_log(guid, order_guid, last_status, status, operate_object, remark, create_by,
                                    create_time)
select uuid()
     , '{orderGuid}'
     , ifnull(
        (select status from coz_order_operation_log where order_guid = '{orderGuid}' order by create_time desc limit 1),
        '0')
     , '2'
     , '2'
     , ''
     , '{curUserId}'
     , now()
from coz_order t
where (t.guid = '{orderGuid}')
  and @Flag1 = '1'
  and @Flag2 = '1'
;


# 组织(服务)模块3.0相关,记录品类交易状态 -- 开始  --
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';

# 查询需方用户的对接专员
select t2.user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_cate_dealstatus_statistic t1
         inner join
     coz_server3_sys_user_dj_bind t2
     on t1.demand_user_id = t2.binded_user_id
where t1.biz_guid = '{orderGuid}'
  and t1.del_flag = '0'
  and t2.user_type = '1';

# 查询供方用户的对接专员
select user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = '{curUserId}'
  and user_type = '2';

# 审批模式:更新品类交易状态为供方取消订单
update coz_server3_cate_dealstatus_statistic
set biz_guid            =@cancelorderguid
,update_time=now()
  , dstatus             = 318
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid = '{orderGuid}'
  and @Flag1 = '1'
  and @Flag2 = '1'
;
# 组织(服务)模块3.0相关,记录品类交易状态 -- 结束  --


select case when (@Flag1 = '1' and @Flag2 = '1') then '1' else '0' end as okFlag
     , case
           when (@Flag1 = '1' and @Flag2 = '1') then ''
           else '当前订单不可取消，请检查是否已经供应完成或已取消' end  as msg