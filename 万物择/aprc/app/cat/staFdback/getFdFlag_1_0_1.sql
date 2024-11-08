-- ##Title app-需方-查询用户对[供方引入中]的品类反馈标志
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-需方-查询用户对[供方引入中]的品类反馈标志
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类Guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
case when exists(select 1 from coz_category_status_feedback where user_id='{curUserId}' and category_guid='{categoryGuid}' and del_flag='0') then '1' else '0' end as fdFlag