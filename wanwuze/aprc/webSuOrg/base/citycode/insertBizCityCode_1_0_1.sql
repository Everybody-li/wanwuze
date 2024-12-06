-- ##Title web-保存选中的行政区域列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-保存选中的行政区域列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizGuid char[36] NOTNULL;签约主体(1：机构，2：个人)，必填
-- ##input parentCode string[30] NOTNULL;签约主体(1：机构，2：个人)，必填
-- ##input code string[30] NOTNULL;签约主体(1：机构，2：个人)，必填
-- ##input allParentId string[200] NOTNULL;签约主体(1：机构，2：个人)，必填
-- ##input id int[>=0] NOTNULL;区域，必填



insert into coz_biz_city_code_temp(guid,biz_guid,nparent_code,ncode,all_parent_id,create_by,create_time,id)
select
UUID()
,'{bizGuid}'
,'{parentCode}'
,'{code}'
,'{allParentId}'
,'{curUserId}'
,now()
,{id}
from
coz_guidance_criterion
where not exists(select 1 from coz_biz_city_code_temp where biz_guid='{bizGuid}' and id={id})
limit 1
;

select 
case when(@flag1='1' and @flag2='1') then '1' else '0' end as okFlag
,case when(@flag1='1' and @flag2='1') then '' else '机构名称已存在，不可新增' end as notOkReason