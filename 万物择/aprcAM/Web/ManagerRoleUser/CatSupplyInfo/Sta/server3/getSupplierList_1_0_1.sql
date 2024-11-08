-- ##Title web-运营经理操作管理-品类供应管理-供应渠道信息管理-供应机构渠道-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询,主查t2的信息,t2和t3是一对多关系,t3有多行就展示多行
-- ##Describe 表名：coz_category_supplier t1,coz_org_info t2,coz_org_info_lgcode t3,coz_lgcode_fixed_data t4
-- ##CallType[QueryData]

-- ##input orgName string[50] NULL;机构名称(模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output orgUserId char[36] ;供应机构用户id
-- ##output orgID string[18] 机构账号ID;机构账号ID
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output orgName string[50] 机构名称;机构名称
-- ##output phonenumber string[50] 登录手机号;登录手机号
-- ##output supplySystem string[50] 供应管理系统;供应管理系统
-- ##output lgcodeGuid string[36] 供应机构code;供应机构code

select 
*
from
(
select 
t2.user_id as orgUserId
,t2.org_ID as orgID
,left(t2.create_time,16) as createTime
,t2.name as orgName
,t2.phonenumber
,t4.login_sysname as supplySystem
,t4.guid as lgcodeGuid
from 
coz_category_supplier t1 
inner join
coz_org_info t2
on t1.user_id=t2.user_id
inner join 
coz_org_info_lgcode t3
on t3.user_id=t2.user_id
inner join
coz_lgcode_fixed_data t4
on t3.lgcode_guid=t4.guid
where t1.del_flag='0' and t2.del_flag='0' and (t2.name like '%坦能高美%' or '坦能高美'='')
)t
group by orgUserId,orgID,createTime,orgName,phonenumber,supplySystem
order by createTime desc
Limit {compute:[({page}-1)*{size}]/compute},{size};
