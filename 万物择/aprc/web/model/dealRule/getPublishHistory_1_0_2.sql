-- ##Title web-查询节点交易规则发布记录
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询节点交易规则发布记录
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


PREPARE q1 FROM '
select
left(t2.publish_time,16) as publishTime
,t1.user_name as userName
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
from
coz_category_deal_rule_log t2
left join
sys_user t1
on t1.user_id=t2.create_by
where 
t2.category_guid=''{categoryGuid}'' and t2.del_flag=''0''
order by t2.publish_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

