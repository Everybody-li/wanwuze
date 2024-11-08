-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-非二维码-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 按月份分组统计 订单的需方是需方供方用户,需方验收通过的数量
-- ##Describe 表名:coz_order t1
-- ##CallType[QueryData]

-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output totalNum int[>=0] ;订单验收通过数量
-- ##output operationMonth char[7] 2023-12;统计时间

select 
left(t1.accept_time,7) as operationMonth
,count(1) as totalNum
from 
coz_order t1
where t1.del_flag='0' 
and t1.accept_status='1'
and t1.demand_user_id='{demandUserId}'
group by left(t1.accept_time,7)
order by left(t1.accept_time,7) desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



