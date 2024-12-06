-- ##Title web-运营经理操作管理-品类采购管理-购方用户信息管理-购方用户成果-非二维码-查看详情-列表上方-括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询 订单的需方是入参需方用户,需方验收通过的数量
-- ##Describe 表名:coz_order t1
-- ##CallType[QueryData]

-- ##input orderNo string[50] NULL;采购编号,模糊搜索
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input demandUserId char[36] NOTNULL;需方用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] ;订单验收通过数量

select 
count(1) as totalNum
from 
coz_order t1
where t1.del_flag='0' 
and t1.accept_status='1'
and t1.demand_user_id='{demandUserId}'
and (t1.order_no like '%{orderNo}%' or '{orderNo}'='')
and left(t1.accept_time,7)='{operationMonth}'


