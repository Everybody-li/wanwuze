-- ##Title app-系统用户申领服务对象
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-系统用户申领服务对象
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input freeUserGuid char[36] NOTNULL;系统用户可领取库guid，必填

SET @guserrecordid = UUID(),@guserrecordlogid = UUID()
;
INSERT INTO coz_guidance_user_record_log(guid,guser_record_guid,source,free_user_guid,user_id,guided_username,guided_user_id,phonenumber,take_back_time,take_back_flag,description,create_by,create_time,unlock_time)
SELECT 
@guserrecordlogid,
@guserrecordid,
'1',
'{freeUserGuid}',
'{curUserId}',
remark_username,
'',
phonenumber,
null,
0,
 '',
'{curUserId}',
now(),
now()
from
coz_guidance_free_user where guid='{freeUserGuid}'
;
INSERT INTO coz_guidance_user_outcome (guid,guser_record_guid,guser_record_log_guid,user_id,guided_user_id,criterion_guid,effective_start_date,effective_end_date,done_flag,done_time,description,del_flag,create_by,create_time,update_by,update_time)
SELECT 
guid,
@guserrecordid,
@guserrecordlogid,
usrt_id,
guided_user_id,
criterion_id,
DATE_ADD(effective_end_date, INTERVAL - effective_days DAY) AS effective_start_date,
effective_end_date,
done_flag,
done_time,
description,
del_flag,
create_by,
create_time,
update_by,
update_time
FROM (
      SELECT guid,
      usrt_id,
      guided_user_id,
      criterion_id,
      DATE_ADD(now(), INTERVAL next_effective_days DAY) AS effective_end_date,
      effective_days,
      done_flag,
      done_time,
      description,
      del_flag,
      create_by,
      create_time,
      update_by,
      update_time
      FROM (
            SELECT 
            UUID() AS guid,
            '{curUserId}' AS usrt_id,
            '' AS guided_user_id,
            guid AS criterion_id,
            effective_days,
            (IFNULL((SELECT sum(effective_days) FROM coz_guidance_criterion WHERE phase < t.phase),0) + effective_days) AS next_effective_days,
             '0' AS done_flag,
             null AS done_time,
             '' AS description,
             '0' AS del_flag,
             '{curUserId}' AS create_by,
             now() AS create_time,
             '{curUserId}' AS update_by,
             now() AS update_time
             FROM coz_guidance_criterion t
             WHERE t.del_flag='0' and NOT EXISTS(SELECT 1
                              FROM coz_guidance_user_outcome
                              WHERE criterion_guid = t.guid
                              AND guser_record_guid = @guserrecordid
                              AND done_flag = 1
				)
                      ) t
             ) t
;

INSERT INTO coz_guidance_user_record(guid,source,free_user_guid,user_id,guided_user_id,guided_username,phonenumber,take_back_flag,take_back_time,description,del_flag,create_by,create_time,update_by,update_time)
SELECT 
@guserrecordid,
'1',
'',
'{curUserId}',
'',
remark_username,
phonenumber,
'0',
null,
'',
'0',
'{curUserId}',
now(),
'{curUserId}',
now()
from
coz_guidance_free_user where guid='{freeUserGuid}'
;
delete from coz_guidance_free_user where guid='{freeUserGuid}'
;