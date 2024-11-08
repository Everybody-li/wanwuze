-- ##Title app-供应-查询供应交接管理列表(待供方处理的订单)
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询供应交接管理列表(待供方处理的订单)
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;供方用户id，必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output orderGuid char[36] 订单guid;订单guid
-- ##output categoryGuid char[36] 品类guid;品类guid
-- ##output categoryImg string[20] 品类图片;品类图片
-- ##output categoryName string[20] 品类名称;品类名称
-- ##output categoryAlias string[200] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[30] 采购编号;采购编号
-- ##output orderTime string[19] 0000-00-00;订单创建时间（格式：0000-00-00）

PREPARE q1 FROM '
select
t.guid as orderGuid
,t.category_guid as categoryGuid
,t1.category_img as categoryImg
,t1.category_name as categoryName
,t1.category_alias as categoryAlias
,t.order_no as orderNo
,left(t.create_time,19) as orderTime
,case when (exists(select 1 from coz_order_cancel a where a.order_guid=t.guid and a.del_flag=''0'' and a.cancel_object=''2'' and a.cancel_user_id=''{curUserId}'' and exists(select 1 from coz_order_judge where order_guid=a.order_guid and del_flag=''0''))) then ''0'' else ''1'' end as cancelBtn
,case when (exists(select 1 from coz_order_cancel a where a.del_flag=''0'' and exists(select 1 from coz_order where guid=t.parent_guid and guid=a.order_guid and del_flag=''0''))) then ''1'' else ''0'' end as relatedCancelFlag
from
coz_order t
left join
coz_demand_request t1
on t.request_guid=t1.guid
where 
t1.sd_path_guid= ''{sdPathGuid}'' and t.supply_user_id= ''{curUserId}'' and t.del_flag=''0'' and t.pay_status= ''2''  and ((t.supply_read_cancel_flag<>''2'' and exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag=''0'' and result=''3'')) or (not exists(select 1 from coz_order_judge where order_guid=t.guid and del_flag=''0'') and t.supply_done_flag=''0''))
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;