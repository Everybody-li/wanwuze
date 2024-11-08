-- ##Title app-应聘-应聘方式管理-目标工作管理-创建目标工作-创建成功后调用
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 1、后端：从t7查询数据value值，查询条件：name=cderequest_auto_recommend，user_id=入参curUserId，若value为off，则此接口不进行任何处理直接终止，若value为空或者为on，则进行以下逻辑处理
-- ##Describe 新增t4：de_request_Guid=t1中查询status=1，send_type=2，cancel_flag=1，user_id<>入参curUserId的Guid，category_Guid=t2表的category_Guid-根据入参recruitGuid从t2获取，只会有1条
-- ##Describe recruit_Guid=入参recruitGuid
-- ##Describe 招聘方信息：recruit_user_name、recruit_user_id、recruit_user_phone、从t6查询获取，t6的Guid=入参curUserId
-- ##Describe recommend_type=2，send_resume_flag=2，其余字段默认值
-- ##Describe 新增t5：根据入参recruitGuid将t3中的数据新增一份到t5，字段参考两个表；t4每新增一行，t5新增一份，t4的每一行Guid对应t5的一份数据的request_supply_Guid
-- ##Describe 2、<p style="color:red">app端：创建招聘信息成功后调用，此接口无需关注返回值，调用即可</p>

-- ##Describe 表名:coz_chat_supply_request_demand t1,coz_chat_employ t2,coz_chat_employ_detail t3
-- ##CallType[ExSql]

-- ##input recruitReimg string[1000] NOTNULL;应聘简介图片，必填
-- ##input recruitGuid char[36] NOTNULL;应聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @requestSupplyGuid=uuid()
;
set @flag1=(select case when exists(select 1 from coz_user_biz_settings where name='csurequest_auto_recommend' and value='0ff' and del_flag='0' and user_id='{curUserId}') then '0' else '1' end)
;
insert into coz_chat_supply_request_demand(guid,de_request_guid,recruit_guid,recruit_user_id,recruit_user_name,recruit_user_phone,recruit_reimg,recommend_type,send_resume_flag,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,t.guid as de_request_guid
,'{recruitGuid}' as recruit_guid
,t1.guid as recruit_user_id
,t1.user_name as recruit_user_name
,t1.phonenumber as recruit_user_phone
,'{recruitReimg}' as recruit_reimg
,'2' as recommend_type
,'2' as send_resume_flag
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,@requestSupplyGuid as update_by
,now()as update_time
from
coz_chat_supply_request t
left join
sys_app_user t1
on t1.guid='{curUserId}'
where
t.status='1' and t.send_type='2' and t.cancel_flag='1' and t.del_flag='0' and t.user_id<>'{curUserId}' and t.category_guid=(select category_guid from coz_chat_employ where guid='{recruitGuid}') and @flag1='1'
;
insert into coz_chat_supply_request_demand_detail(guid,request_supply_guid,fd_code,fd_name,fd_value,status,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,t1.guid as request_supply_guid
,t.fd_code
,(select name from coz_model_fixed_data where guid=t.fd_guid) as fd_name
,t.fd_value
,t.status
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
from
coz_chat_employ_detail t
inner join
coz_chat_supply_request_demand t1
on t1.update_by=@requestSupplyGuid
where 
t.employ_guid='{recruitGuid}' and @flag1='1'
;

