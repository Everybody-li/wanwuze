-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户成果管理/供方对接成果管理-二维码-查看供应渠道数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类订单验收通过数量,按供应机构guid分组统计办理申请点击数量
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_detail t2,coz_org_info t3,coz_org_info_lgcode t4,coz_lgcode_fixed_data t5,coz_org_info t6
-- ##CallType[QueryData]


-- ##input operationMonth char[7] NOTNULL;2023-12;统计时间(办理申请点击时间)
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input orgName string[30] NULL;机构名称或联系电话(模糊搜索)

-- ##output totalNum int[>=0] 10;数量

select
ifnull(sum(totalNum),0) as totalNum
from
(
select
orgUserId
,operationTime
,orgID
,createTime
,supplySystem
,orgName
,phonenumber
,count(1) as totalNum
from
(
select 
t4.user_id as orgUserId
,left(t2.create_time,7) as operationTime
,t4.org_ID as orgID
,left(t4.create_time,19) as createTime
,(select a.login_sysname from coz_lgcode_fixed_data a where a.guid=t3.lgcode_guid and a.del_flag='0') as supplySystem
,t4.name as orgName
,concat('(+86)',t4.phonenumber) as phonenumber
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_server3_cate_dealstatus_statistic_detail t2
on t1.guid=t2.statistic_guid
left join
coz_cattype_sd_path t3
on t1.sd_path_guid=t3.guid
inner join
coz_org_info t4
on t2.supply_user_id=t4.user_id
where t1.del_flag='0' 
and t2.del_flag='0' 
and t4.del_flag='0' 
and t2.price_way='2'
and (('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}') or ('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}') or ('{targetUserType}'='3' and t1.category_guid='{targetUserId}'))
and left(t2.create_time,7)='{operationMonth}' and (t4.name like '%{orgName}%' or t4.phonenumber like '%{orgName}%' or '{orgName}'='')
)t
group by orgUserId,operationTime,orgID,createTime,supplySystem,orgName,phonenumber
)t



