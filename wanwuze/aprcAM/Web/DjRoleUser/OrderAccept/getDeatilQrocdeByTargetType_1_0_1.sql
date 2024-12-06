-- ##Title web-对接专员操作管理-购方/供方对接管理-购方用户成果管理/供方对接成果管理-二维码-查看详情(办理申请点击)
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 查询 目标所属类型的品类订单验收通过数量,按办理申请点击时间倒序
-- ##Describe 按供应机构guid分组
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,coz_server3_cate_dealstatus_statistic_detail t2,coz_org_info t3
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input operationMonth char[7] 2023-12;统计时间
-- ##input categoryName string[50] NULL;品类名称或购方信息,模糊搜索
-- ##input targetUserType enum[1,2,3,4] NOTNULL;目标所属类型:1-购方(需方)用户,2-供方用户,3-品类名称
-- ##input targetUserId char[36] NOTNULL;目标guid(需方对接专员用户id或供方对接专员用户id或品类名称guid)
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input orgUserId char[36] 供应机构用户guid;供应机构用户guid
-- ##input supplySystemGuid char[36] 供应管理系统guid;供应管理系统guid

-- ##output orgUserId char[36] ;供应机构guid
-- ##output operationTime char[19] 2023-12-12 12:23:45;办理申请点击日期
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output orgName string[100] ;供应机构(渠道)名称
-- ##output modelName string[50] ;型号名称
-- ##output supplyUserPhone string[50] (+86)18650767213;供方信息
-- ##output demandUserPhone string[50] (+86)18650767213;购方信息

select
*
from
(
select 
t4.user_id as orgUserId
,left(t2.create_time,19) as operationTime
,t5.name as categoryName
,t5.cattype_name as cattypeName
,t4.name as orgName
,t2.biz_name as modelName
,concat('(+86)',t2.supply_user_phone) as supplyUserPhone
,concat('(+86)',t6.phonenumber) as demandUserPhone
,t1.id
from 
coz_server3_cate_dealstatus_statistic t1
inner join
coz_server3_cate_dealstatus_statistic_detail t2
on t1.guid=t2.statistic_guid
inner join
coz_org_info t4
on t2.supply_user_id=t4.user_id
inner join
coz_category_info t5
on t1.category_guid=t5.guid
left join
sys_app_user t6
on t1.demand_user_id=t6.guid
left join
coz_cattype_sd_path t7
on t1.sd_path_guid=t7.guid
left join
coz_lgcode_fixed_data t8
on t8.guid=t7.lgcode_guid and t8.del_flag='0'
where t1.del_flag='0' 
and t2.del_flag='0' 
and t4.del_flag='0' 
and t5.del_flag='0' 
and t2.price_way='2'
and (('{targetUserType}'='1' and t1.demand_sys_user_guid='{targetUserId}') or ('{targetUserType}'='2' and t1.supply_sys_user_guid='{targetUserId}') or ('{targetUserType}'='3' and t1.category_guid='{targetUserId}')) and t4.user_id='{orgUserId}' and t8.guid='{supplySystemGuid}'
and left(t2.create_time,7)='{operationMonth}'
and (t5.name like '%{categoryName}%' or t2.supply_user_phone like '%{categoryName}%'or '{categoryName}'='')
)t1
group by orgUserId,operationTime,categoryName,cattypeName,orgName,modelName,supplyUserPhone,demandUserPhone,t1.id
order by operationTime desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



