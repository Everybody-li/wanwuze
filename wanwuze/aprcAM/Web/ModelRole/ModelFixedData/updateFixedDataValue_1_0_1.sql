-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-编辑库内容-修改
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 新增,修改的时候需要额外维护 level,parent_guid,all_parent_id,path_value
-- ##CallType[ExSql]

-- ##input fixedDataValueGuid char[36] NOTNULL;内容guid，必填
-- ##input parentGuid char[36] NOTNULL;上一段内容guid，必填
-- ##input value string[100] NOTNULL;本段节点名称，必填
-- ##input curUserId string[36] NOTNULL;当前登录用户id

set @flag1=case when(not exists(select 1 from coz_model_fixed_data_value where value='{value}' and parent_guid='{parentGuid}' and del_flag='0')) then '1' else '0' end
;
set @parentLevel=ifnull((select `level` from coz_model_fixed_data_value where guid = '{parentGuid}'),0)
;
set @maxNorder=(ifnull((select (max(norder)+1) from coz_model_fixed_data_value where parent_guid='{parentGuid}' and del_flag='0'),1))
;
set @newAllParentId=(select ifnull((select concat(ifnull(all_parent_id,''),id,',') from coz_model_fixed_data_value where guid = '{parentGuid}'),',0,'))
;
set @oldAllParentId=(select ifnull((select ifnull(all_parent_id,'') from coz_model_fixed_data_value where guid = '{fixedDataValueGuid}'),',0,'))
;
set @vid=ifnull((select concat(id,',') from coz_model_fixed_data_value where guid = '{fixedDataValueGuid}'),0)
;
set @newPathValue=(select ifnull((select concat(ifnull(path_value,''),'{value}',',') from coz_model_fixed_data_value where guid = '{parentGuid}'),',0,'))
;
set @oldPathValue=(select ifnull((select ifnull(path_value,'') from coz_model_fixed_data_value where guid = '{fixedDataValueGuid}'),',0,'))
;
update coz_model_fixed_data_value 
set end_nodes_count = end_nodes_count+(
select sum(end_nodes_count) from (
select count(1) as end_nodes_count from coz_model_fixed_data_value 
where (guid='{fixedDataValueGuid}' or all_parent_id like concat('%',@oldAllParentId,@vid,'%')) and del_flag='0'
)t )
where (@newAllParentId) like concat('%,',id,',%') and @flag1='1'
;
update coz_model_fixed_data_value 
set end_nodes_count = end_nodes_count-(
select sum(end_nodes_count) from (
select count(1) as end_nodes_count from coz_model_fixed_data_value 
where (guid='{fixedDataValueGuid}' or all_parent_id like concat('%',@oldAllParentId,@vid,'%')) and del_flag='0'
)t )
where (@oldAllParentId) like concat('%,',id,',%') and @flag1='1'
;
update coz_model_fixed_data_value
set all_parent_id=case when (@parentLevel=0 and guid='{fixedDataValueGuid}') then ',' else replace(all_parent_id,@oldAllParentId,@newAllParentId) end
,path_value=case when (@parentLevel=0 and guid='{fixedDataValueGuid}') then concat(',',value,',') else replace(path_value,@oldPathValue,@newPathValue) end
,`level`=`level`-(`level`-(@parentLevel+1))
,norder=case when(guid='{fixedDataValueGuid}') then  @maxNorder else norder end
,parent_guid=case when(guid='{fixedDataValueGuid}') then '{parentGuid}' else parent_guid end
,value=case when(guid='{fixedDataValueGuid}') then '{value}' else value end
,update_by='{curUserId}'
,update_time=now()
where (guid='{fixedDataValueGuid}' or all_parent_id like concat('%',@oldAllParentId,@vid,'%')) and del_flag='0' and @flag1='1'
;


