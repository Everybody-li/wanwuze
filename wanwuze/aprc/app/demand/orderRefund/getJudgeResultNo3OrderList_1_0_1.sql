-- ##Title app-采购-查询退货交接订单列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询退货交接订单列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output judgeGuid char[36] 仲裁guid;仲裁guid
-- ##output judgeResult int[>=0] 1;裁决结果：0：-未裁决，1-需方违约，支持退款（需方取消订单），2-供方违约，支持退款（供方取消订单、供方货不对板），3-交易正常，维持交易（符合需求信息），4-交易取消，支持退款（有关联订单取消，导致本订单取消）
-- ##output supplyUserId char[36] 供方用户id;供方用户id
-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output orderNo string[24] 采购编号;采购编号
-- ##output orderRefundGuid char[36] 订单退货guid;订单退货guid
-- ##output orderCancelGuid char[36] 订单取消guid;订单取消guid
-- ##output orderTime string[10] 订单日期;订单日期（格式：0000-00-00）
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output categoryalias string[50] 品类别名;品类别名，多个逗号隔开
-- ##output orderCatVirtualFlag string[1] 1;订单品类产品类型（0：非实物产品，1：实物产品）

PREPARE q1 FROM '
select
*
from
(
select 
t2.guid as judgeGuid
,t2.result as judgeResult
,t3.supply_user_id as supplyUserId
,t1.order_guid as orderGuid
,t3.order_no as orderNo
,t1.guid as orderRefundGuid
,'''' as orderCancelGuid
,left(t3.create_time,10) as orderTime
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,t3.need_deliver_flag as orderCatVirtualFlag
from 
coz_order_refund t1
left join 
coz_order_judge t2
on t2.biz_guid=t1.guid 
left join 
coz_order t3 
on t1.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t3.demand_user_id=''{curUserId}'' and (t2.result=''1'' or t2.result=''2'') and t1.prove_logistic_img='''' and t1.prove_supply_sign_date is null and t3.sd_path_guid=''{sdPathGuid}''
union all
select 
t2.guid as judgeGuid
,t2.result as judgeResult
,t3.supply_user_id as supplyUserId
,t1.order_guid as orderGuid
,t3.order_no as orderNo
,'''' as orderRefundGuid
,t1.guid as orderCancelGuid
,left(t3.create_time,10) as orderTime
,t4.guid as categoryGuid
,t4.img as categoryImg
,t4.name as categoryName
,t4.alias as categoryAlias
,t3.need_deliver_flag as orderCatVirtualFlag
from 
coz_order_cancel t1
left join 
coz_order_judge t2
on t2.biz_guid=t1.guid 
left join 
coz_order t3 
on t1.order_guid=t3.guid 
left join 
coz_category_info t4
on t3.category_guid=t4.guid 
where 
t3.demand_user_id=''{curUserId}'' and (t2.result=''1'' or t2.result=''2'') and (t1.refund_pay_status=''2'' or t1.refund_pay_status=''3'') and t3.sd_path_guid=''{sdPathGuid}''
)t
order by orderTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;