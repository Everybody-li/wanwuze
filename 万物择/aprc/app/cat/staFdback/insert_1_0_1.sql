-- ##Title app-需方-对[供方引入中]的品类进行反馈
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-需方-对[供方引入中]的品类进行反馈
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类Guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_category_status_feedback where user_id='{curUserId}' and category_guid='{categoryGuid}' and del_flag='0') then '0' else '1' end)
;
insert into coz_category_status_feedback(guid,user_id,category_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,'{curUserId}' as curUserId
,'{categoryGuid}' as categoryGuid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion
where
@flag1='1'
limit 1
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前品类您已反馈过，请耐心等待~' else '操作成功' end as msg
;