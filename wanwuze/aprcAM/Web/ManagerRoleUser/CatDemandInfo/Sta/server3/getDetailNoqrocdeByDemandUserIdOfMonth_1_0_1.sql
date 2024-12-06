-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-非二维码-查看详情-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 按月份查询 订单的需方是入参需方用户,需方验收通过的订单列表
-- ##Describe 表名:coz_order t1,coz_demand_request t2
-- ##CallType[QueryData]

-- ##input orderNo string[50] NULL;采购编号,模糊搜索
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output operationTime char[19] 2023-12-12 12:23:45;订单验收通过日期
-- ##output orderNo string[50] 采购编号;采购编号
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称

select 
left(t1.accept_time,7) as operationTime
,t1.order_no as orderNo
,t2.category_name as categoryName
,t2.cattype_name as cattypeName
from 
coz_order t1
inner join
coz_demand_request t2
on t1.request_guid=t2.guid
where t1.del_flag='0' 
and t1.accept_status='1'
and t1.demand_user_id='{demandUserId}'
and (t1.order_no like '%{orderNo}%' or '{orderNo}'='')
and left(t1.accept_time,7)='{operationMonth}'
Limit {compute:[({page}-1)*{size}]/compute},{size};


