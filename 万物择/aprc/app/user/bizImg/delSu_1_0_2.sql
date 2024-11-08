-- ##Title app-采购-删除用户业务图片
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-删除用户业务图片
-- ##CallType[ExSql]

-- ##input bizImgGuid char[36] NOTNULL;供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


update coz_user_biz_img 
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{bizImgGuid}'
;
