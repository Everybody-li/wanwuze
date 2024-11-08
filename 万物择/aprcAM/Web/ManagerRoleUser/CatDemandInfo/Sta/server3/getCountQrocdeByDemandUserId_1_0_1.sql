-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-二维码-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 按月份分组统计 t2.需方是入参需方用户,报价方式是二维码的行数
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic_detail t1,coz_server3_cate_dealstatus_statistic t2
-- ##CallType[QueryData]

-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output totalNum int[>=0] ;办理申请点击数量
-- ##output operationMonth char[7] 2023-12;统计时间

select 
left(t1.create_time,7) as operationMonth
,count(1) as totalNum
from 
coz_server3_cate_dealstatus_statistic_detail t1
inner join
coz_server3_cate_dealstatus_statistic t2
on t1.statistic_guid=t2.guid
where t1.del_flag='0' 
and t2.demand_user_id='{demandUserId}'
and t1.price_way='2'
group by left(t1.create_time,7)
order by left(t1.create_time,7) desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



