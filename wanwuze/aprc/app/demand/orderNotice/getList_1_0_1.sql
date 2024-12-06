-- ##Title 采购-反馈-采购消息通知_1_0_1
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 采购-反馈-采购消息通知_1_0_1
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select
t.guid as orderNoticeGuid
,t1.category_guid as categoryGuid
,t2.img as categoryImg
,t2.name as categoryName
,t2.alias as categoryAlias
,t1.order_no as orderNo
,t1.create_time as orderTime
,t.create_time as noticeCreateTime
,t.read_flag as readFlag
,t.type as noticeType
,t.biz_guid as bizGuid
,t1.guid as orderGuid
from
coz_order_notice t
left join
coz_order t1
on t.order_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
where 
t.cat_tree_code=''demand'' and t.del_flag=''0'' and t.user_id=''{curUserId}''
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;