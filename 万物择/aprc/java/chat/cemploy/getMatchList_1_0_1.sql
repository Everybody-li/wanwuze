-- ##Title 根据品类guid及招聘内容查询招聘信息详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据品类guid及招聘内容查询招聘信息详情
-- ##Describe 过滤条件：
-- ##Describe t1的生效状态为生效，t1的category_Guid=入参categoryGuid，
-- ##Describe t2的过滤条件为value1，value2，value5,t3的status=1，
-- ##Describe t3无数据不影响返回结果，t3有数据则t3的type <> 3 且 t3的type <> 5
-- ##Describe t4无数据不影响返回结果，t4有数据则t4的type <> 3 且 t3的type <> 5
-- ##Describe 按t1的Guid去重
-- ##CallType[QueryData]

-- ##input categoryGuid string[36] NOTNULL;品类guid，必填
-- ##input value1 string[36] NOTNULL;fd_code=c10001的值,单个，必填
-- ##input value2 string[36] NOTNULL;fd_code=c10002的值,单个，必填
-- ##input value5 string[36] NOTNULL;fd_code=c10005的值,单个，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output employGuid char[36] 应聘信息Guid;应聘信息Guid
-- ##output userId string[36] 应聘方用户id;应聘方用户id

select
employGuid
,userId
from
(
select
t1.guid as employGuid
,t1.user_id as userId
,
(
select
rowcount
from
(
select
t1.guid as employGuid
,count(1) as rowcount
from
coz_chat_employ t1
left join
coz_chat_employ_detail t2
on t1.guid=t2.employ_guid
where
t1.category_guid='{categoryGuid}' and t1.status='1' and t1.del_flag='0' and t2.del_flag='0' and
((t2.fd_code='c10001' and t2.fd_value='{value1}') or  (t2.fd_code='c10002' and t2.fd_value='{value2}') or  (t2.fd_code='c10005' and t2.fd_value='{value5}'))
group by t1.guid
)a where a.employGuid=t1.guid
) as rowcount
from
coz_chat_employ t1
left join
coz_chat_employ_detail t2
on t1.guid=t2.employ_guid
where
t1.category_guid='{categoryGuid}' and t1.status='1' and t1.del_flag='0' and t2.del_flag='0' and
((t2.fd_code='c10001' and t2.fd_value='{value1}') or  (t2.fd_code='c10002' and t2.fd_value='{value2}')  or  (t2.fd_code='c10005' and t2.fd_value='{value5}') )
)t
-- app需要匹配的字段数量
where rowcount=3
GROUP BY employGuid,userId