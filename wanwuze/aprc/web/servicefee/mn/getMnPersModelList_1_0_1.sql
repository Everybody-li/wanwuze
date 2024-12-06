-- ##Title web-查询某一品类服务定价供方型号列表-按型号名称_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询某一品类服务定价供方型号列表-按型号名称_1_0_1
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input modelGuid char[36] NOTNULL;品类guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
t.guid as serviceFeeMnGuid
,t.category_guid as categoryGuid
,t.model_guid as modelGuid
,case when (t.target_object=''demand'') then ''需方'' when (t.target_object=''supply'') then ''供方'' else ''暂未设置'' end as targetObject
,case when (t.charge_type=''1'') then ''按比例'' when (t.charge_type=''2'') then ''按数值'' else ''其他'' end as chargeType
,case when (t.charge_type=''1'') then concat(t.charge_value,''%'') when (t.charge_type=''2'') then concat(''￥'',t.charge_value) else ''其他'' end as chargeValue
,left(t.create_time,16) as createTime
,left(t.start_date,10) as startDate
,left(t.end_date,10) as endDate
from
coz_category_service_fee_mn t
where
t.category_guid=''{categoryGuid}''and t.del_flag=''0'' and t.model_guid=''{modelGuid}''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;