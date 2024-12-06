-- ##Title web-查询某一品类收取服务定价列表-按型号类型_1_0_1
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询某一品类收取服务定价列表-按型号类型_1_0_1
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
t.category_guid as categoryGuid
,case when (t.target_object=''demand'') then ''需方'' when (t.target_object=''supply'') then ''供方'' else ''暂未设置'' end as targetObject
,case when (t.charge_type=''1'') then ''按比例'' when (t.charge_type=''2'') then ''按数值'' else ''其他'' end as chargeType
,concat(t.mcharge_value,''%'') as mchargeValue
,concat(t.nomcharge_value,''%'') as nomchargeValue
,left(create_time,16) as createTime
from
coz_category_service_fee_mt_log t
where
category_guid=''{categoryGuid}''and del_flag=''0''
order by id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;