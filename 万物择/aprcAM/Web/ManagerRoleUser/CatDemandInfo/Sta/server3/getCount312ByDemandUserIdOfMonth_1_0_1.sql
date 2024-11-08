-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-二维码-查看供应渠道-列表上方-办理申请点击括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 统计 t1.需方是入参需方用户,报价方式是二维码的数量
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic_detail t1,coz_org_info t2
-- ##CallType[QueryData]

-- ##input orgID string[18] NULL;机构账号ID
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] ;办理申请点击数量

select 
count(1) as totalNum
from 
coz_server3_cate_dealstatus_statistic_detail t1
inner join
coz_server3_cate_dealstatus_statistic t2
on t1.statistic_guid=t2.guid
inner join
coz_org_info t3
on t1.supply_user_id=t3.user_id
where t1.del_flag='0' 
and t2.demand_user_id='{demandUserId}'
and (t3.org_ID like '%{orgID}%' or '{orgID}'='')
and t1.price_way='2'
and left(t1.create_time,7)='{operationMonth}'


