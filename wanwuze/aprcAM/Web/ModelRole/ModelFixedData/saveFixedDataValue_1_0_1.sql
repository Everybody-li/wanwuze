-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-编辑库内容-新增
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增品类字节内容
-- ##CallType[ExSql]

-- ##input parentGuid string[36] NOTNULL;上一段字节内容guid（前端判断，没有上一段字节内容,传0），必填
-- ##input fixedDataGuid char[36] NOTNULL;固化内容信息库guid
-- ##input value string[100] NOTNULL;本段节点名称，必填
-- ##input curUserId string[36] NOTNULL;当前登录用户id

update coz_model_fixed_data_value
set end_nodes_count=end_nodes_count+1
,update_by='{curUserId}'
,update_time=now()
where 
id in({url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\ModelRole\ModelFixedData\allParentId1&DBC=w_a&parentGuid={parentGuid}&OnlyTagReturn=true]/url})
;
INSERT INTO coz_model_fixed_data_value
(
guid
,parent_guid
,all_parent_id
,path_value
,level
,norder
,fixed_data_guid
,value
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select 
UUID()
,'{parentGuid}' as parent_guid
,ifnull((select CONCAT(ifnull(all_parent_id,''),id,',') from coz_model_fixed_data_value where guid = '{parentGuid}'),',') as all_parent_id
,CONCAT(ifnull((select concat(ifnull(value,''),',') from coz_model_fixed_data_value where guid = '{parentGuid}'),','),'{value}',',') as path_value
,ifnull((select level from coz_model_fixed_data_value where guid='{parentGuid}'),0)+1 as level
,ifnull((select (max(norder)+1) from coz_model_fixed_data_value where parent_guid='{parentGuid}' and del_flag='0' and fixed_data_guid='{fixedDataGuid}'),1) as norder
,'{fixedDataGuid}' as fixedDataGuid
,'{value}' as value
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time
where 
not exists(select 1 from coz_model_fixed_data_value where value='{value}' and parent_guid='{parentGuid}' and del_flag='0' and fixed_data_guid='{fixedDataGuid}')
limit 1
