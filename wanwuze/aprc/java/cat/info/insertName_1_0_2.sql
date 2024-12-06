-- ##Title 新增品类信息
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增品类信息
-- ##CallType[ExSql]


-- ##input secenGuid char[36] NOTNULL;末级场景guid，必填
-- ##input mode string[1] NOTNULL;品类模式（1：沟通模式，2：交易模式），必填
-- ##input categoryGuid char[36] NOTNULL;品类名称guid，必填
-- ##input categoryName string[500] NOTNULL;品类名称，必填
-- ##input loginCode string[2] NULL;品类所属登录系统code，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input cattypeName string[500] NOTNULL;品类类型名称，必填
-- ##input dealRuleGuid char[36] NOTNULL;品类类型的节点交易规则guid，必填
-- ##input priceMode enum[1,2] NOTNULL;品类类型的节点交易规则报价模式，必填
-- ##input serveFeeFlag enum[0,1] NOTNULL;品类类型的节点交易规则收取服务费标志，必填
-- ##input publishTime char[19] NULL;品类类型的节点交易规则发布时间
-- ##input curUserId char[36] NOTNULL;当前登录用户id，必填

set @deadlineguid=uuid()
;

INSERT INTO coz_category_info 
(guid,code,name,alias,mode,login_code,cattype_guid,cattype_name,active,del_flag,create_by,create_time,update_by,update_time) 
select 
'{categoryGuid}' as guid
,'' as code
,'{categoryName}' as name
,'' as alias
,'{mode}' as mode
,'{loginCode}' as loginCode
,'{cattypeGuid}' as cattypeguid
,'{cattypeName}' as cattypename
,1 as active
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
;

INSERT INTO coz_category_deal_mode
(category_guid,cattype_guid,del_flag,create_by,create_time,update_by,update_time) 
select
'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattypeguid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
where '{mode}' =2
;


INSERT INTO coz_category_supply_price
(category_guid,cattype_guid,del_flag,create_by,create_time,update_by,update_time) 
select
'{categoryGuid}' as categoryGuid
,'{cattypeGuid}' as cattype_guid
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
where '{mode}' =2
;


insert into coz_category_deal_deadline (guid,cattype_guid,category_guid,day,del_flag,create_by,create_time,update_by,update_time)
select
@deadlineguid as guid
,'{cattypeGuid}' as cattype_guid
,'{categoryGuid}' as categoryGuid
,day
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_category_deal_deadline
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0' and day>0
order by id desc
limit 1
;
insert into coz_category_deal_deadline_log (guid,deadline_guid,category_guid,day,del_flag,create_by,create_time,update_by,update_time)
select
uuid() as guid
,@deadlineguid as deadline_guid
,'{categoryGuid}' as categoryGuid
,day
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_category_deal_deadline
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0' and day>0
order by id desc
limit 1
;
insert into coz_category_deal_deadline (guid,cattype_guid,category_guid,day,del_flag,create_by,create_time,update_by,update_time)
select
@deadlineguid as guid
,'{cattypeGuid}' as cattype_guid
,'{categoryGuid}' as categoryGuid
,day
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_category_deal_deadline
where '{mode}'='2' and category_guid='{cattypeGuid}' and del_flag='0' and day=0
order by id desc
limit 1;

insert into coz_category_deal_rule (guid, category_guid, cattype_guid,price_mode,serve_fee_flag,publish_time,publish_flag,create_by, create_time, update_by,update_time)
select 
'{dealRuleGuid}'
,'{categoryGuid}'
,'{cattypeGuid}'
,'{priceMode}'
,'{serveFeeFlag}'
,if(''='{publishTime}',null,now()) 
,if(''='{publishTime}',0,'2') 
,'{curUserId}'
,now() 
,'{curUserId}'
,now()
where '{mode}' =2
;






