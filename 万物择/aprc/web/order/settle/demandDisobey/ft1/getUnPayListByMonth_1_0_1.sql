-- ##Title web-结算管理-未结算
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-结算管理-未结算
-- ##CallType[QueryData]

-- ##input month string[7] NOTNULL;验收通过月份（格式：0000-00），必填
-- ##input orderNo string[20] NULL;采购编号（后端模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output judgeGuid char[36] 裁决guid;裁决guid
-- ##output judgeFeeGuid char[36] 裁决费用guid;裁决费用guid
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output judgeTime string[10] 0000-00-00;裁决结果日期（格式：0000-00-00）
-- ##output categoryName string[20] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output orderNo string[20] 采购编号;采购编号
-- ##output demandUserId char[36] 供方用户id;供方用户id
-- ##output userName string[200] 需方用户姓名;需方用户姓名
-- ##output userNation string[30] 需方用户区号;需方用户区号
-- ##output userPhonenumber string[30] 用户手机号;用户手机号
-- ##output userId char[36] 需方用户id;需方用户id
-- ##output disobeyFee decimal[>=0] 1;（违约金）结算金额（保留2位小数）

PREPARE q1 FROM '
select
t4.guid as judgeGuid
,t.guid as judgeFeeGuid
,left(t4.result_time,10) as judgeTime
,t2.name as categoryName
,t2.cattype_name as cattypeName
,t1.order_no as orderNo
,t4.order_guid as orderGuid

,t3.user_name as userName
,t3.nation as userNation
,t3.phonenumber as userPhonenumber
,t3.phonenumber
,t3.guid as demandUserId
,''1'' as demandUserType
,t1.supply_user_id as supplyUserId
,''2'' as supplyUserType
,cast(t.fee/100 as decimal(18,2)) as disobeyFee
,t1.request_guid as requestGuid
,t1.request_price_guid as requestPriceGuid
from
coz_order_judge_fee t
left join
coz_order_judge t4
on t4.guid=t.judge_guid
left join
coz_order t1
on t4.order_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
left join
sys_app_user t3
on t1.demand_user_id=t3.guid
where 
left(t.create_time,7)=''{month}'' and t.del_flag=''0'' and (t1.order_no like ''%{orderNo}%'' or ''{orderNo}''='''') and t.fee_type=''1'' and t4.disobey_object=''1'' and t.confirm_pay_flag=''1''
order by t4.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;