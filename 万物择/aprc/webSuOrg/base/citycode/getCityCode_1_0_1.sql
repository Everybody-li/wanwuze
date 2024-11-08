-- ##Title 已
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 已
-- ##CallType[QueryData]

-- ##input code string[30] NOTNULL;父级code，必填
-- ##input bizCode string[30] NOTNULL;父级code，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid char[36] NOTNULL;业务guid，必填

select
case when(
-- (baseChildrenCount=bizChildrenCount and bizChildrenCount>0) or 
iszji=1) then '2' when(
-- (baseChildrenCount>bizChildrenCount and bizChildrenCount>0) or 
iszji1=1) then '1' 
-- when(bizChildrenCount=0) then '0' 
when('{code}'='-1' and iszji2=1)
then '1' 
else '0' end as selectedFlag
,t.*
from
(
select 
case when exists(select 1 from sys_city_code where parent_code=t.code) then '1' else '0' end as hasSon
-- ,(select count(1) from sys_city_code where all_parent_id like concat('%,',t.id,',%') and guid<>t.guid) as baseChildrenCount
-- ,case when (exists(select 1 from coz_biz_city_code_temp where nparent_code='{code}'and biz_guid='{bizGuid}')) then (select count(1) from coz_biz_city_code_temp where all_parent_id like concat('%,',t.id,',%') and biz_guid='{bizGuid}') else 0 end as bizChildrenCount
,code
,id
,parent_code as parentCode
,all_parent_id as allParentId
,name
,case when exists(select 1 from coz_biz_city_code_temp where biz_guid='{bizGuid}' and t.all_parent_id like concat('%',all_parent_id,'%')) then 1 else 0 end as iszji
,case when exists(select 1 from coz_biz_city_code_temp where biz_guid='{bizGuid}' and all_parent_id like concat('%,',t.id,'%')) then 1 else 0 end as iszji1
,case when exists(select 1 from coz_biz_city_code_temp where biz_guid='{bizGuid}') then 1 else 0 end as iszji2
from sys_city_code t
where t.parent_code='{code}'
)t
order by code

