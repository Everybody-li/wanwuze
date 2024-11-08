-- ##Title web-交易专员-保存选中的品类类型列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-交易专员-保存选中的品类类型列表
-- ##CallType[ExSql]

-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input roleKey string[50] NOTNULL;目标用户角色类型，必填
-- ##input userId string[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @flag1=(select case when exists(select 1 from coz_cattype_fixed_data where guid='{cattypeGuid}' and del_flag='0') then '1' else '0' end)
;
set @flag2=(select case when not exists(select 1 from coz_server2_sys_user_cattype where cattype_guid='{cattypeGuid}' and del_flag='0' and user_id='{userId}' and role_key='{roleKey}') then '1' else '0' end)
;
insert into coz_server2_sys_user_cattype(guid,user_id,role_key,cattype_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{userId}' as user_id
,'{roleKey}' as role_key
,'{cattypeGuid}' as cattypeGuid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_cattype_fixed_data
where 
guid='{cattypeGuid}' and @flag1='1' and @flag2='1'
;
select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '无效品类类型，请联系管理员！' when(@flag2='0') then '当前用户已设置该品类类型，请重新选择！' else '操作成功' end as msg