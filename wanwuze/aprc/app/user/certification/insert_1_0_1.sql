-- ##Title app-提交实名认证
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-提交实名认证
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;用户id
-- ##input realname string[15] NOTNULL;姓名
-- ##input idType int[>=0] NOTNULL;证件类型
-- ##input idNumber string[500] NOTNULL;证件号码
-- ##input effectiveStartDate datetime[yyyy-MM-dd] NOTNULL;证件有效开始时间
-- ##input effectiveEndDate datetime[yyyy-MM-dd] NOTNULL;证件有效结束时间
-- ##input issuanceOrgan string[40] NOTNULL;签发机关
-- ##input imgs string[1000] NOTNULL;认证图片（GUID,用逗号隔开）


insert into coz_app_user_certification(guid,user_id,realname,ID_type,ID_number,effective_start_date,effective_end_date,issuance_organ,imgs,del_flag,create_by,create_time,update_by,update_time)
value (uuid(),'{curUserId}','{realname}','{idType}','{idNumber}','{effectiveStartDate}','{effectiveEndDate}','{issuanceOrgan}','{imgs}','0','{curUserId}',now(),'{curUserId}',now())
