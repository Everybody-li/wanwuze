-- ##Title web-运营经理操作管理-品类供应管理-供应渠道成果管理-二维码-查看详情-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询 t1.供方是入参供方用户,报价方式是二维码的列表数据
-- ##Describe 表名:coz_server3_cate_dealstatus_statistic_detail t1,coz_category_supplier_am_model t2
-- ##CallType[QueryData]

-- ##input supplyUserPhone string[50] NULL;购方信息,模糊搜索
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input operationMonth char[7] NOTNULL;统计月份:0000-00
-- ##input supplyUserId char[36] NOTNULL;供应渠道用户id
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output operationTime char[19] 2023-12-12 12:23:45;办理申请点击日期
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output orgName string[100] ;供应机构(渠道)名称
-- ##output modelName string[50] ;型号名称
-- ##output supplyUserPhone string[50] (+86)18650767213;购方信息

select 
left(t1.create_time,7) as operationMonth
,t4.name as categoryName
,t4.cattype_name as cattypeName
,t1.supply_user_name as orgName
,t1.biz_name as modelName
,concat('(+86)',t1.supply_user_phone) as supplyUserPhone
from 
coz_server3_cate_dealstatus_statistic_detail t1
inner join
coz_category_supplier_am_model t2
on t1.biz_guid=t2.guid
inner join
coz_category_supplier t3
on t2.supplier_guid=t3.guid
inner join
coz_category_info t4
on t3.category_guid=t4.guid
where t1.del_flag='0' 
and t2.del_flag='0' 
and t3.del_flag='0' 
and t4.del_flag='0' 
and t1.supply_user_id='{supplyUserId}'
and t1.price_way='2'
and (t1.supply_user_phone like '%{supplyUserPhone}%' or '{supplyUserPhone}'='')
and left(t1.create_time,7)='{operationMonth}'
order by t1.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};


