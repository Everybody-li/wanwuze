-- ##Title web-关联采购路径和供应路径
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-关联采购路径和供应路径
-- ##CallType[ExSql]

-- ##input cattypeGuid char[36] NOTNULL;订单退货guid，必填
-- ##input demandPathGuid char[36] NOTNULL;订单退货guid，必填
-- ##input supplyPathGuid char[36] NOTNULL;订单退货guid，必填
-- ##input norder int[>=0] NOTNULL;app路径顺序，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @flag1=(select case when exists(select 1 from coz_cattype_sd_path where demand_path_guid='{demandPathGuid}' and del_flag='0') then '0' else '1' end)
;
set @flag2=(select case when exists(select 1 from coz_cattype_sd_path where supply_path_guid='{supplyPathGuid}' and del_flag='0') then '0' else '1' end)
;
set @flag3=(select case when exists(select 1 from coz_cattype_sd_path where norder='{norder}' and del_flag='0') then '0' else '1' end)
;
insert into coz_cattype_sd_path(guid,cattype_guid,demand_path_guid,supply_path_guid,norder,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{cattypeGuid}'
,'{demandPathGuid}'
,'{supplyPathGuid}'
,'{norder}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
;
select 
case when(@flag1='1' and @flag2='1' and @flag3='1') then '1' else '0' end as okFlag
,case when(@flag1='0') then '当前采购路径已关联其他供应路径，不可再次关联' when(@flag2='0') then '当前供应路径已关联其他采购路径，不可再次关联'  when(@flag3='0') then '排序重复，请调整'  else '操作成功' end as msg