-- ##Title web-查看供应退货退款意见反馈列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看供应退货退款意见反馈列表-已回复
-- ##CallType[QueryData]

-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;用户id，必填

PREPARE q1 FROM '
select 
t.guid as feedbackGuid
,left(t.create_time,10) as createTime
,t.reply_flag as replyFlag
,t.reply_content_read_flag as readFlag
from  
coz_order_refund_feedback t
where 
 t.del_flag=''0'' and t.cat_tree_code=''supply''
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

