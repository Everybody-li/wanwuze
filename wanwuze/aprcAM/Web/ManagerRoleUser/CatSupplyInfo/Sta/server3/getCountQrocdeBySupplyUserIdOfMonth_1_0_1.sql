-- ##Title web-运营经理操作管理-品类供应管理-供应渠道成果管理-二维码-查看详情-列表上方-括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询 t1.供方是入参供方用户,报价方式是二维码的行数
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic_detail t1,coz_category_info t2
-- ##CallType[QueryData]

-- ##input supplyUserPhone string[50] NULL;购方信息,模糊搜索
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input supplyUserId char[36] NOTNULL;供应渠道用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalNum int[>=0] ;办理申请点击数量

select 
count(1) as totalNum
from 
coz_server3_cate_dealstatus_statistic_detail t1
where t1.del_flag='0' 
and t1.supply_user_id='{supplyUserId}'
and (t1.supply_user_phone like '%{supplyUserPhone}%' or '{supplyUserPhone}'='')
and t1.price_way='2'
and left(t1.create_time,7)='{operationMonth}'


