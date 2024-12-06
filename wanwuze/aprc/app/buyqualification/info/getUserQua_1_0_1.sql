-- ##Title app-采购-查询品类是否有采购资质要求
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询品类是否有采购资质要求
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input userId string[36] NOTNULL;供方用户id，必填


select
case when (quaFlag1='0') then '0' else '1' end as quaFlag
,t1.guid as qualificationUserGuid
,quaFlag1 as qualificationLogGuid
,case when (quaFlag1='0') then '-1' else t1.status end as userQuaStatus
,case when (quaFlag1='0') then '-1' else t1.approve_flag end as userQuaAF
,case when (quaFlag1='0') then '-1' else t1.approve_remark end as userQuaAFRemark
from
(
select
case when exists(select 1 from coz_category_buy_qualification_log where category_guid='{categoryGuid}' and del_flag='0') then (
select 
guid
from
coz_category_buy_qualification_log
where 
category_guid='{categoryGuid}' and del_flag='0'
order by id desc
limit 1
)
else '0' end as quaFlag1
)t
left join
coz_category_buy_qualification_user t1
on t.quaFlag1=t1.qualification_log_guid
