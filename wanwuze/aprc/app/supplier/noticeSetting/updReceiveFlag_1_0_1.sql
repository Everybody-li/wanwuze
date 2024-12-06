-- ##Title app-供应-设置接收设置开关
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-设置接收设置开关
-- ##CallType[ExSql]

-- ##input noticeGuid string[36] NULL;消息通知guid，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input receiveFlag int[>=0] NOTNULL;消息提醒标志：0-关闭，1-开启，必填

update coz_supplier_notice_setting
set receive_flag='{receiveFlag}'
,update_by='{curUserId}'
,update_time=now()
where 
guid='{noticeGuid}'
;
insert into coz_supplier_notice_setting(guid,user_id,receive_flag,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{curUserId}'
,'{receiveFlag}'
,'0'
,'1'
,now()
,'1'
,now()
from 
coz_cattype_fixed_data
where '{noticeGuid}'=''
limit 1
;