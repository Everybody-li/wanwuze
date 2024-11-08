-- ##Title web-运营经理操作管理-品类供应管理-供应渠道成果管理-二维码-列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 按月份分组统计 t1.供方是入参供方用户,报价方式是二维码的行数
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic_detail t1
-- ##CallType[QueryData]

-- ##input supplyUserId char[36] NOTNULL;供应渠道用户id
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
where t1.del_flag='0' 
and t1.supply_user_id='{supplyUserId}'
and t1.price_way='2'
group by left(t1.create_time,7)
order by left(t1.create_time,7) desc
Limit {compute:[({page}-1)*{size}]/compute},{size};



