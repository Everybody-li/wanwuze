-- ##Title web-运营经理操作管理-品类供应管理-供应渠道成果管理-非二维码-列表上方-括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询 订单的供方是入参供方用户,需方验收通过的数量
-- ##Describe 表名:coz_order t1
-- ##CallType[QueryData]

-- ##input orderNo string[50] NULL;采购编号,模糊搜索
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input supplyUserId char[36] NOTNULL;供应渠道用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] ;订单验收通过数量

select 
count(1) as totalNum
from 
coz_order t1
where t1.del_flag='0' 
and t1.accept_status='1'
and t1.supply_user_id='{supplyUserId}'
and (t1.order_no like '%{orderNo}%' or '{orderNo}'='')
and left(t1.accept_time,7)='{operationMonth}'


