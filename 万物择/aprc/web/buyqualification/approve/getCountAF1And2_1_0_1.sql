-- ##Title web-统计用户申请的资质审批(通过/不通过)数量
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-统计用户申请的资质审批(通过/不通过)数量
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类最新资质guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output approveF1Count int[>=0] 1;审批通过数量
-- ##output approveF2Count int[>=0] 1;审批不通过数量

select 
(select count(1) from coz_category_buy_qualification_user where category_guid='{categoryGuid}' and approve_flag='1') as approveF1Count
,(select count(1) from coz_category_buy_qualification_user where category_guid='{categoryGuid}' and approve_flag='2') as approveF2Count