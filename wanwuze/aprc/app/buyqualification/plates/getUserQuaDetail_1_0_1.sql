-- ##Title web-查询用户资质详情
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询用户资质详情
-- ##CallType[QueryData]

-- ##input qualificationUserGuid string[500] NOTNULL;订单guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.status
,case when (t.status='0') then '版本已过期，作废' else t.approve_remark end as approveRemark
,t.approve_flag as approveFlag
,CONCAT('{ChildRows_aprc\\app\\buyqualification\\plates\\getPlates_1_0_1:qualificationUserGuid=''',t.guid,'''}') as `plate`
from
coz_category_buy_qualification_user t
where
t.guid='{qualificationUserGuid}' and t.del_flag='0'