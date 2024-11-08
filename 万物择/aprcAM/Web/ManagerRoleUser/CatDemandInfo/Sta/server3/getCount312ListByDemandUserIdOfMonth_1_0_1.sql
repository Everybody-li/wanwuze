-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-二维码-查看供应渠道-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询 t1.需方是入参需方用户,报价方式是二维码的数据
-- ##Describe 出参办理申请点击 是t1的行数
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic_detail t1,coz_org_info t2,coz_category_info t3,coz_category_supplydemand t4,coz_category_scene_tree t5,coz_cattype_sd_path t6,coz_cattype_supply_path t7,coz_cattype_supply_path_lgcode t8,coz_lgcode_fixed_data t9
-- ##CallType[QueryData]

-- ##input orgID string[18] NULL;机构账号ID
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output supplyUserId char[36] 供方用户id(供应渠道用户id);供方用户id(供应渠道用户id)
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output totalNum int[>=0] 1;办理申请点击数量
-- ##output supplyLgCodeGuid char[36] 供方登录系统guid;供方登录系统guid

select
supplyUserId
,orgID
,createTime
,orgName
,phonenumber
,supplySystem
,supplyLgCodeGuid
,count(1) as totalNum
from
(
select 
t1.supply_user_id as supplyUserId
,t3.org_ID as orgID
,left(t3.create_time,7) as createTime
,t3.name as orgName
,concat('(+86)',t3.phonenumber) as phonenumber
,(select a.login_sysname from coz_lgcode_fixed_data a where a.guid=t4.lgcode_guid and a.del_flag='0') as supplySystem
,t4.lgcode_guid as supplyLgCodeGuid
from 
coz_server3_cate_dealstatus_statistic_detail t1
inner join
coz_server3_cate_dealstatus_statistic t2
on t1.statistic_guid=t2.guid
inner join
coz_org_info t3
on t1.supply_user_id=t3.user_id
left join
coz_cattype_sd_path t4
on t2.sd_path_guid=t4.guid
where t1.del_flag='0' 
and t2.del_flag='0' 
and t3.del_flag='0' 
and t2.demand_user_id='{demandUserId}'
and t1.price_way='2'
and (t3.org_ID like '%{orgID}%' or '{orgID}'='')
and left(t1.create_time,7)='{operationMonth}'
)t
group by supplyUserId,orgID,createTime,orgName,phonenumber,supplySystem,supplyLgCodeGuid
order by createTime
Limit {compute:[({page}-1)*{size}]/compute},{size};


