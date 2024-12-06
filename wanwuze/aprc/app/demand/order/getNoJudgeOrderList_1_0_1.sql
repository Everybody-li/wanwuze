-- ##Title app-采购-查询成果交接管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-采购-查询成果交接管理列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
categoryName
,categoryalias
,categoryImg
,orderTime
,orderNo
,orderGuid

from
(
select 
t1.guid as orderGuid
,t2.category_name as categoryName
,t2.category_img as categoryImg
,t2.category_alias as categoryAlias
,left(t1.create_time,10) as orderTime
,t1.order_no as orderNo

,t1.need_deliver_flag

from  
coz_order t1
left join 
coz_demand_request t2
on t1.request_guid=t2.guid 
where 
t1.demand_user_id=''{curUserId}'' and t1.del_flag=''0'' and t2.sd_path_guid=''{sdPathGuid}'' and t1.pay_status=''2''
)t
order by orderTime desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;