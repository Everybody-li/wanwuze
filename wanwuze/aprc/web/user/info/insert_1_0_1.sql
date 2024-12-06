-- ##Title web-新建用户账号信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新建用户账号信息
-- ##Describe 场景专员：sceneRole、c4f05fc3-f470-11ec-bace-0242ac120003
-- ##Describe 品类专员：categoryRole、e21bc62f-f470-11ec-bace-0242ac120003
-- ##Describe 型号专员：modelRole、bf69be16-f472-11ec-bace-0242ac120003
-- ##Describe 信息专员：customerServiceRole、1e1841c2-040e-11ed-b3e9-00163e2ca549
-- ##Describe 定价专员：pricingRole、ea2fd6ce-040e-11ed-b3e9-00163e2ca549
-- ##Describe 用户专员：dxzyRole、a69523d0-1aab-11ed-9049-00163e2ca549
-- ##Describe 仲裁专员：judgeRole、1425f8db-21f0-11ed-afde-00163e2ca549
-- ##Describe 结算专员：settleRole、e71d1356-290f-11ed-afde-00163e2ca549  
-- ##Describe 招募专员：zmhrRole、5e0d2c26-4e4c-11ed-afde-00163e2ca549
-- ##Describe 供应专员：gyRole、5e0d4eab-4e4c-11ed-afde-00163e2ca549
-- ##Describe 沟通调度专员：commuRole、75313e4a-8c9c-11ed-afde-00163e2ca549
-- ##Describe 沟通专员：commuStaffRole、75313ec4-8c9c-11ed-afde-00163e2ca549
-- ##Describe 服务调度专员：serveRole、75314cc0-8c9c-11ed-afde-00163e2ca549  
-- ##Describe 服务专员：serveRole、75314d4c-8c9c-11ed-afde-00163e2ca549
-- ##Describe 询价调度专员：askPriceRole、0a873baf-a2aa-11ed-ad4d-00163e2ca549
-- ##Describe 询价专员：askPriceStaffRole、75313cfd-8c9c-11ed-afde-00163e2ca549
-- ##Describe 交易专员：dealStaffRole、75313dcd-8c9c-11ed-afde-00163e2ca549
-- ##Describe 运营经理：operationManagerRole、75314db6-8c9c-11ed-afde-00163e2ca549
-- ##Describe 供应专员2：gy2Role、f96b8a77-b64b-11ed-ad4d-00163e2ca549
-- ##Describe 供需专员：modelSonRole、7935c8f2-efdf-11ed-ad4d-00163e2ca549
-- ##Describe 图片专员：imgRole、786a83a8-efdf-11ed-ad4d-00163e2ca549
-- ##Describe 服务专员: duijieRole、493e22fc-4d21-11ee-8398-00163e2ca549
-- ##Describe 上架专员: shangjiaRoled、4c780d6-4d21-11ee-8398-00163e2ca549
-- ##Describe 选拔专员: xuanbaMode3Role、6cfc22a9-746d-11ee-b2f3-00163e2ca549
-- ##Describe 服务主管: duijieDirectorRole、5d4c26ce-9e2e-11ee-814e-00163e2ca549
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input userName string[50] NOTNULL;修改用户id，必填
-- ##input deptId string[50] NOTNULL;归属部门，非必填
-- ##input passwd string[100] NOTNULL;用户密码密文，非必填
-- ##input nickName string[50] NOTNULL;用户姓名，非必填
-- ##input phonenumber string[50] NOTNULL;手机号码，非必填
-- ##input status string[50] NOTNULL;帐号状态（0：正常 1：停用），非必填
-- ##input roleKey string[100] NOTNULL;角色类型，必填

set @flag1=(select case when not exists (select 1 from sys_user where user_name='{userName}' and del_flag='0') then '1' else '0' end)
;
set @flag2=(select case when not exists (select 1 from sys_role a left join sys_user_role b on b.role_id=a.role_id left join sys_user c on c.user_id=b.user_id where a.role_key='{roleKey}' and a.del_flag='0' and  c.del_flag='0' and c.phonenumber='{phonenumber}') then '1' else '0' end)
;
set @userid=uuid()
;
set @exValue=left(CEILING(RAND()*900000+100000),6)
;
insert into sys_user(user_id,dept_id,user_name,nick_name,phonenumber,password,status,del_flag,create_by,create_time,update_by,update_time)
select
@userid
,'{deptId}'
,'{userName}'
,'{nickName}'
,'{phonenumber}'
,'{passwd}'
,'{status}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
from
coz_cattype_fixed_data t
where
@flag1='1' and @flag2='1'
limit 1
;
insert into sys_user_role(user_id,role_id)
select
@userid
,role_id
from
sys_role
where 
role_key='{roleKey}' and @flag1='1' and @flag2='1'
limit 1
;
insert into sys_role_dept(role_id,dept_id)
select
role_id
,'{deptId}'
from
sys_role t
where 
role_key='{roleKey}' and not exists(select 1 from sys_role_dept where role_id=t.role_id and dept_id='{deptId}') and @flag1='1' and @flag2='1'
limit 1
;
insert into sys_user_extra
(
guid
,user_guid
,ex_key
,ex_value
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
uuid()
,@userid
,'1'
,@exValue
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
where 
'{roleKey}'='duijieRole' and not exists(select 1 from sys_user_extra where user_guid=@userid and ex_key='1' and ex_value=@exValue) and @flag1='1' and @flag2='1'
;
