-- ##Title app-审批模式下的品类- 需方-品类交易状态埋点-办理申请点击(点击一次,调用一次)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 新增 品类交易状态数据t1和t2,品类交易状态为:312-办理申请点击,对接专员用户取需方的对接专员
-- ##Describe t1:同一需求guid不重复保存,t2:接口调用一次保存一次
-- ##Describe 查出当前需方服务专员关联的服务主管,有就新增dsdo,查出供方服务专员关联的服务主管,有就新增dsdo
-- ##Describe 表名： coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_detail t2,coz_server3_sys_user_dj_bind t3 coz_server3_cate_dealstatus_statistic_detail_outcome dsdo
-- ##CallType[ExSql]

-- ##input requestGuid char[36] NOTNULL;渠道需求guid
-- ##input categoryGuid char[36] NOTNULL;品类名称guid
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input priceWay string[1] NOTNULL;品类型号模式：报价方式：1-非二维码，2-二维码
-- ##input modelGuid char[36] NOTNULL;品类供方型号guid
-- ##input modelName string[50] NOTNULL;品类供方型号名称
-- ##input curUserId char[36] NOTNULL;当前登录用户id

set @statisticGuid = ifnull((select guid
                             from coz_server3_cate_dealstatus_statistic
                             where biz_guid = '{requestGuid}'
                               and del_flag = '0'), uuid())
;
set @statisticDetailGuid=uuid()
;
# 供方用户id
set @supplyUserId = ''
;
# 需方用户id
set @demandUserId = ''
;
# 供方用户名称
set @supplyUserName = ''
;
# 供方用户手机号
set @supplyUserPhone = ''
;
# 供方用户对接专员guid
set @SupplySysUserGuid = ''
;
# 需方用户对接专员guid
set @DemandSysUserGuid= ''
;
# 根据型号guid查询供方用户信息
select t3.user_id,
       t3.name,
       t3.phonenumber
into @supplyUserId,@supplyUserName,@supplyUserPhone
from coz_category_supplier t1
         inner join coz_category_supplier_am_model t2 on t1.guid = t2.supplier_guid
         inner join coz_org_info t3 on t1.user_id = t3.user_id
where t2.guid = '{modelGuid}'
  and t2.del_flag = '0'
  and t1.del_flag = '0'
;
# 根据需求guid查询需方用户信息

select t1.user_id
into @demandUserId
from
(
select t1.user_id
from coz_demand_request t1
where t1.guid = '{requestGuid}'
  and t1.del_flag = '0'
union
select t1.user_id
from coz_aprom_pre_demand_request t1
where t1.guid = '{requestGuid}'
  and t1.del_flag = '0'
)t1
limit 1
;
# 查询供方用户关联的对接专员信息
select user_guid
into @SupplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = @supplyUserId
  and user_type = 2
;
# 查询需方用户关联的对接专员信息
select user_guid
into @DemandSysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = @demandUserId
  and user_type = 1
;
update coz_server3_cate_dealstatus_statistic
set dstatus     = 312,
    demand_sys_user_guid=@DemandSysUserGuid,
    supply_sys_user_guid=@SupplySysUserGuid,
    supply_user_id=@supplyUserId,
    supply_user_name=@supplyUserName,
    supply_user_phone=@supplyUserPhone,
    update_time = now(),
    update_by   = '{curUserId}'
where guid = @statisticGuid;

insert into coz_server3_cate_dealstatus_statistic_detail
( guid
, statistic_guid
, price_way
, biz_guid
, biz_name
, nstatus
, sys_user_guid
, supply_user_id
, supply_user_name
, supply_user_phone
, del_flag
, create_by
, create_time)
select @statisticDetailGuid
     , @statisticGuid
     , '{priceWay}'       as price_way
     , '{modelGuid}'      as biz_guid
     , (select name from coz_category_supplier_am_model where guid = '{modelGuid}') as biz_name
     , '312'              as nstatus
     , @SupplySysUserGuid as sys_user_guid
     , @supplyUserId      as supply_user_id
     , @supplyUserName    as supply_user_name
     , @supplyUserPhone   as supply_user_phone
     , 0                  as del_flag
     , '{curUserId}'      as create_by
     , now()              as create_time
;
insert into coz_server3_cate_dealstatus_statistic_detail_outcome
( 
guid
,statistic_detail_guid
,sys_user_guid
,cat_tree_code
,create_by
,create_time
,del_flag
)
select uuid()
     , @statisticDetailGuid
     , binded_suser_guid       as sys_user_guid
     , 'demand'      as cat_tree_code
     , '{curUserId}'      as create_by
     , now()              as create_time
     , 0                  as del_flag
from
coz_server3_sys_user_bind
where
bind_suser_guid=@DemandSysUserGuid
;
insert into coz_server3_cate_dealstatus_statistic_detail_outcome
( 
guid
,statistic_detail_guid
,sys_user_guid
,cat_tree_code
,create_by
,create_time
,del_flag
)
select uuid()
     , @statisticDetailGuid
     , binded_suser_guid       as sys_user_guid
     , 'supply'      as cat_tree_code
     , '{curUserId}'      as create_by
     , now()              as create_time
     , 0                  as del_flag
from
coz_server3_sys_user_bind
where
bind_suser_guid=@SupplySysUserGuid
;