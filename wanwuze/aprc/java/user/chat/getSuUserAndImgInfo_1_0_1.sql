-- ##Title 根据用户id及供应路径查询用户信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据用户id及供应路径查询用户信息
-- ##CallType[QueryData]

-- ##input supplyPathGuid char[36] NOTNULL;供应路径guid，必填
-- ##input userId string[1000] NOTNULL;用户id(可能会有多个)，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
t1.guid as userId
,t1.user_name as userName
,t1.phonenumber as userPhone
,t2.img as supplyReimg
from
sys_app_user t1
left join
(
select 
a.*
from
coz_user_biz_img a
right join
(select user_id,max(id) as MID from coz_user_biz_img where supply_path_guid='{supplyPathGuid}' group by user_id) b
on a.id=b.MID
) t2
on t1.guid=t2.user_id
where
t2.supply_path_guid='{supplyPathGuid}' and t1.status='0' and t1.guid in ({userId})  and t2.del_flag ='0'

