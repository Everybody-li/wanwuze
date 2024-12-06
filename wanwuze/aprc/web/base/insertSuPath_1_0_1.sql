-- ##Title web-新增采购路径名称
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-新增采购路径名称
-- ##CallType[ExSql]

-- ##input cattypeGuid char[36] NOTNULL;订单退货guid，必填
-- ##input parentGuid char[36] NOTNULL;订单退货guid，必填
-- ##input type string[1] NOTNULL;主体类型（1：个人，2：企业），必填
-- ##input name string[50] NOTNULL;路径名称，必填
-- ##input appNorder int[>=0] NOTNULL;app路径顺序，必填
-- ##input worgNorder int[>=0] NOTNULL;app路径顺序，必填
-- ##input wsceneNorder int[>=0] NOTNULL;app路径顺序，必填
-- ##input displayType string[1] NOTNULL;主体类型（1：个人，2：企业），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_cattype_supply_path(guid, cattype_guid, parent_guid, all_parent_id,all_path_name,name,level,norder,app_norder,wscene_norder,worg_norder,display_type,remark,icon,type,del_flag, create_by, create_time, update_by,update_time)
select
uuid()
,'{cattypeGuid}'
,'{parentGuid}'
,concat((select concat(all_path_name,'>') from coz_cattype_supply_path where guid='{parentGuid}'),'{name}')
,case when ('{parentGuid}'='0') then '' when ((select level from coz_cattype_supply_path where guid='{parentGuid}')=1) then (select concat(',',id) from coz_cattype_supply_path where guid='{parentGuid}') else (select concat(all_parent_id,',',id) from coz_cattype_supply_path where guid='{parentGuid}') end
,'{name}'
,case when ('{parentGuid}'='0') then '1' else (select level+1 from coz_cattype_supply_path where guid='{parentGuid}') end
,'{appNorder}'
,'{appNorder}'
,'{wsceneNorder}'
,'{worgNorder}'
,'{displayType}'
,''
,'{icon}'
,'{type}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()