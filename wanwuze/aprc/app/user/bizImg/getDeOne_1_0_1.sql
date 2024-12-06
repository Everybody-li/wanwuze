-- ##Title app-采购-查询用户业务图片
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询用户业务图片
-- ##CallType[QueryData]

-- ##input demandPathGuid char[36] NOTNULL;采购路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
guid as bizImgGuid
,img
from
coz_user_biz_img t
where user_id='{curUserId}' and demand_path_guid='{demandPathGuid}' and del_flag='0'
;
