-- ##Title web-审批用户资质
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-审批用户资质
-- ##CallType[ExSql]

-- ##input qualificationUserGuid char[36] NOTNULL;品类用户资质guid，必填
-- ##input approveFlag int[>=0] NOTNULL;审批状态（1：审批通过，2：审批不通过），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

update coz_category_buy_qualification_user
set approve_flag='{approveFlag}'
,approve_remark=concat(left(now()+0,8),if(('{approveFlag}'='1'),'审批状态(通过)','审批状态(不通过)'))
,update_by='{curUserId}'
,update_time=now()
where 
guid='{qualificationUserGuid}'