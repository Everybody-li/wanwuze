-- ##Title web-查询供需需求信息发布记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询供需需求信息发布记录
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


-- ##output publishTime String[19] 发布时间;发布时间（格式：0000年00月00日 00:00）

PREPARE q1 FROM '
select
concat(left(t2.publish_time,4),''年'',right(left(t2.publish_time,7),2),''月'',right(left(t2.publish_time,10),2),''日'',right(left(t2.publish_time,16),6)) as publishTime
,t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
from
coz_category_deal_mode_log t2
left join
sys_user t1
on t1.user_id=t2.create_by
where t2.category_guid=''{categoryGuid}''
order by t2.publish_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;