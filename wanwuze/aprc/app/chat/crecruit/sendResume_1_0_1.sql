-- ##Title app-应聘方-应聘投递
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-应聘方-应聘投递
-- ##Describe 新增t1：相同deRequestGuid、recruitGuid、recommend_type不重复保存，
-- ##Describe de_request_Guid=入参deRequestGuid，
-- ##Describe recruit_Guid=入参recruitGuid，
-- ##Describe recruit_user_id=入参userId，
-- ##Describe recruit_user_name=入参userName，
-- ##Describe recruit_user_phone=入参userPhone，
-- ##Describe recruit_user_reimg=入参reimg，
-- ##Describe recommend_type=入参recType，其余字段默认值
-- ##Describe 新增t2：根据入参recruitGuid将t4中的数据新增一份到t2，字段参考两个表，t2增加了列fd_value_Guid，记得补上
-- ##Describe 新增t3：
-- ##Describe 相同t1的Guid不重复新增，
-- ##Describe cat_tree_code=‘demand’，
-- ##Describe request_supply_Guid=t1的Guid，t1和t3都只会有一条数据
-- ##Describe user_id=入参curUserId，
-- ##Describe target_user_id=入参userId，
-- ##Describe category_Guid=入参categoryGuid，其余字段默认值
-- ##Describe 接口类型：中间件
-- ##Describe 表名：
-- ##Describe 沟通模式-应聘需求供方(招聘方)招聘信息表：coz_chat_demand_request_supply t1
-- ##Describe 应聘需求供方(招聘方)招聘信息详情表：coz_chat_demand_request_supply_detail t2
-- ##Describe 应聘招聘用户在线沟通好友申请表：coz_chat_friend_apply t3 
-- ##Describe 沟通模式-招聘信息内容详情表：coz_chat_recruit_detail   t4 
-- ##CallType[ExSql]

-- ##input deRequestGuid char[36] NOTNULL;应聘需求guid，必填
-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input reimg string[50] NOTNULL;招聘方简介图片，必填
-- ##input userId char[36] NOTNULL;招聘方用户id，必填
-- ##input userName string[50] NOTNULL;招聘方用户姓名，必填
-- ##input userPhone string[11] NOTNULL;招聘方用户姓名，必填
-- ##input recType string[1] NOTNULL;投递类型(app：1：查找用人单位后立即投递，2：投递等待投递)，必填
-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input categoryName string[500] NOTNULL;品类名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @requestSupplyGuid=uuid()
;
insert into coz_chat_demand_request_supply_detail(guid,request_supply_guid,fd_code,fd_name,fd_value_guid,fd_value,status,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,@requestSupplyGuid as request_supply_guid
,fd_code
,(select name from coz_model_fixed_data where guid=t.fd_guid) as fd_name
,fd_value_guid
,fd_value
,status
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
from
coz_chat_recruit_detail t
where 
recruit_guid='{recruitGuid}'
;
insert into coz_chat_friend_apply (guid,cat_tree_code,user_id,target_user_id,recruit_guid,request_supply_guid,category_guid,category_name,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'demand' as catTreeCode
,'{curUserId}' as userId
,'{userId}' as supplyUserId
,'{recruitGuid}' as recruitGuid
,@requestSupplyGuid as request_supply_guid
,'{categoryGuid}' as category_guid
,'{categoryName}' as category_name
,'0' as del_flag
,'-1' as create_by
,now() as create_time
,'-1' as update_by
,now() as update_time
from
sys_app_user
where
guid='{curUserId}' and not exists(select 1 from coz_chat_friend_apply where user_id='{curUserId}' and target_user_id='{userId}' and  recruit_guid='{recruitGuid}')
;
insert into coz_chat_demand_request_supply(guid,de_request_guid,recruit_guid,recruit_user_id,recruit_user_name,recruit_user_phone,recruit_reimg,recommend_type,del_flag,create_by,create_time,update_by,update_time)
select
@requestSupplyGuid as guid
,'{deRequestGuid}' as de_request_guid
,'{recruitGuid}' as recruit_guid
,'{userId}' as recruit_user_id
,'{userName}' as recruit_user_name
,'{userPhone}' as recruit_user_phone
,'{reimg}' as recruit_reimg
,'{recType}' as recommend_type
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
from
coz_model_fixed_data
where not exists(select 1 from coz_chat_demand_request_supply where de_request_guid='{deRequestGuid}' and recruit_guid='{recruitGuid}' and recommend_type='{recType}' and del_flag='0')
limit 1
;


update  coz_chat_demand_request
set send_type = '1'
where guid = '{deRequestGuid}'
  and send_type = '0';
