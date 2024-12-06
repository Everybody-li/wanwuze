-- ##Title java-审批模式-渠道需求提交-渠道需求保存
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 新增t1,t2
-- ##Describe t1:根据入参新增
-- ##Describe t2:业务guid为渠道需求guid,品类节点状态为311,对接专员为供方关联的对接专员(通过aprcAM\Com\Utils\DjBind\getCurDjBindType2User_1_0_1获取)
-- ##Describe 表名： coz_aprom_pre_demand_request t1,coz_server3_cate_dealstatus_statistic t2
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;渠道需求guid
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input sdPathAllName string[100] NOTNULL;采购供应路径全路径名称
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid
-- ##input cattypeName string[50] NOTNULL;品类类型名称
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input categoryName string[500] NOTNULL;品类名称
-- ##input curUserId char[36] NOTNULL;当前登录用户id


insert into coz_aprom_pre_demand_request
(
guid
,sd_path_guid
,sd_path_all_name
,cattype_guid
,cattype_name
,category_guid
,category_name
,user_id
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
'{requestGuid}' as guid
,'{sdPathGuid}' as sdPathGuid
,'{sdPathAllName}' as sdPathAllName
,'{cattypeGuid}' as cattypeGuid
,'{cattypeName}' as cattypeName
,'{categoryGuid}' as sdPathAllName
,'{categoryName}' as categoryName
,'{curUserId}' as user_id
,0 as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
;
insert into coz_server3_cate_dealstatus_statistic
(
guid
,cattype_guid
,sd_path_guid
,category_guid
,category_mode
,biz_guid
,dstatus
,demand_user_id
,demand_sys_user_guid
,supply_sys_user_guid
,supply_user_id
,supply_user_name
,supply_user_phone
,del_flag
,create_by
,create_time
,update_by
,update_time
)
select
uuid()
,t.cattype_guid
,'{sdPathGuid}' as sdPathGuid
,t.guid as category_guid
,t.mode as category_mode
,'{requestGuid}' as biz_guid
,'311' as dstatus
,'{curUserId}' as demand_user_id
,(select user_guid from coz_server3_sys_user_dj_bind where binded_user_id='{curUserId}' limit 1) as demand_sys_user_guid
,'' as supply_sys_user_guid
,'' as supply_user_id
,'' as supply_user_name
,'' as supply_user_phone
,0 as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now() as update_time
from
coz_category_info t
where guid='{categoryGuid}' and del_flag='0'