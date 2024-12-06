-- ##Title web机构-审批模式-切换合作项目-订单供应-成果交接-办理通知-办理
-- ##Author 卢文彪
-- ##CreateTime 2023-07-18
-- ##Describe 新增
-- ##Describe 表名：coz_order_am_notice t1
-- ##CallType[ExSql]

-- ##input noticeGuid char[36] NOTNULL;办理通知guid，前端通过获取guid接口自己获取一个
-- ##input orderGuid char[36] NOTNULL;订单guid
-- ##input doneTime string[50] 2023年10月xxxxx;办理时间，手动输入
-- ##input place string[200] 办理地点;办理地点
-- ##input contactPerson string[20] 联系人;联系人
-- ##input contactPhone string[18] 联系电话;联系电话
-- ##input curUserId char[36] NOTNULL;当前登录用户id

insert into coz_order_am_notice
(
guid
,order_guid
,time
,place
,contact_person
,contact_phone
,del_flag
,create_by
,create_time
,update_by
,update_time

)
select
'{noticeGuid}' as guid
,'{orderGuid}' as orderGuid
,'{doneTime}' as time
,'{place}' as place
,'{contactPerson}' as contactPerson
,'{contactPhone}' as contactPhone
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
;
insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,'{orderGuid}'
,ifnull((select status from coz_order_operation_log where order_guid='{orderGuid}' order by create_time desc limit 1),'0')
,'10'
,'2'
,''
,'{curUserId}'
,now()
from
coz_order t
where (t.guid='{orderGuid}') 
;



set @demandSysUserGuid = '';
set @supplySysUserGuid = '';
set @demandUserGuid = '';

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

# 审批模式:更新品类交易状态-供方办理通知
update coz_server3_cate_dealstatus_statistic
set dstatus             = 320
  , update_time=now()
  , demand_sys_user_guid=@demandSysUserGuid
  , supply_sys_user_guid=@supplySysUserGuid
where biz_guid =  '{orderGuid}';
