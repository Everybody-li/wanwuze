-- ##Title web-进行投放
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-进行投放
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input cattypeGuid string[36] NOTNULL;品类类型guid，必填
-- ##input freeNum int[>=0] NOTNULL;投放数量，必填

set @flag1=(select case when ({freeNum}>2000) then '0' else '1' end)
;
set @freeGuid=uuid()
;
set @batchNo=uuid()
;
insert into coz_serve_tbuser_free_detail(guid,free_guid,seorg_glog_guid,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,@freeGuid as free_guid
,guid seorg_glog_guid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,@batchNo as update_by
,now() as update_time
from
(
select t1.guid from coz_serve_org_gain_log t1 inner join coz_app_phonenumber t2 on t1.object_phonenumber=t2.phonenumber where t1.cattype_guid='{cattypeGuid}' and t1.takeback_flag='1' and t1.free_flag='0' and @flag1='1' order by t2.id limit {freeNum}
)t
where @flag1='1'
;
insert into coz_serve_tbuser_free(guid,cattype_guid,free_num,real_num,del_flag,create_by,create_time,update_by,update_time)
select
@freeGuid as guid
,'{cattypeGuid}' as cattype_guid
,{freeNum} as free_num
,(select count(1) from coz_serve_tbuser_free_detail where update_by=@batchNo) as real_num
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_guidance_criterion t
where @flag1='1'
limit 1
;
update coz_serve_org_gain_log t
set free_flag='1'
,free_time=now()
,free_by='{curUserId}'
where 
exists(
select 1 from coz_serve_tbuser_free_detail where update_by=@batchNo and seorg_glog_guid=t.guid
)
;
select 
case when(@flag1='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '单次投放最多2000个服务对象！' else '操作成功' end as notOkReason