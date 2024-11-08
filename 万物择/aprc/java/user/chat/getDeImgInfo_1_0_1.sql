-- ##Title 根据用户id及供应路径查询用户信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据用户id及供应路径查询用户信息
-- ##CallType[QueryData]

-- ##input demandPathGuid char[36] NOTNULL;采购路径guid，必填
-- ##input userId char[36] NOTNULL;用户id
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select t1.guid        as userId
     , t1.user_name   as userName
     , t1.phonenumber as userPhone
     , t2.img         as demandReimg
from sys_app_user t1
         left join coz_user_biz_img t2 on t1.guid = t2.user_id
where t1.del_flag = '0'
  and t2.del_flag = '0'
  and t2.demand_path_guid = '{demandPathGuid}'
  and t1.status = '0'
  and t1.guid in ({userId})

