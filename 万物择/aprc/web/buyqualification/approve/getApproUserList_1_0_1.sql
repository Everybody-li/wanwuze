-- ##Title web-查询品类资质用户列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类资质用户列表
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input phonenumber string[11] NULL;用户电话号码，必填
-- ##input approveFlag int[>=0] NOTNULL;审批状态（1：审批通过，2：审批不通过），必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output qualificationGuid char[36] 品类资质guid;品类资质guid
-- ##output userId char[36] 用户id;用户id
-- ##output userName string[50] 用户姓名;用户姓名
-- ##output nation string[50] 区号;区号
-- ##output phonenumber string[50] 用户电话号码;用户电话号码
-- ##output userTag int[>=0] 1;用户角色类型
-- ##output approveRemark string[50] 审批意见;审批意见
-- ##output status int[>=0] 1;状态(1-生效中，2-已过期）
-- ##output approveFlag int[>=0] 1;审批标志(0-未审批，1-审批通过，2-审批不通过)

PREPARE q1 FROM '
select
t.guid as qualificationUserGuid
,t.category_guid as categoryGuid
,t1.guid as userId
,t1.user_name as userName
,t1.nation as nation
,t1.phonenumber as phonenumber
,t1.user_tag as userTag
,t.approve_remark as approveRemark
,t.status
,t.approve_flag as approveFlag
from
coz_category_buy_qualification_user t
left join 
sys_app_user t1
on t.user_id=t1.guid
left join 
coz_category_info t2
on t.category_guid=t2.guid
where 
t.category_guid=''{categoryGuid}'' and t.approve_flag=''{approveFlag}''  and t.del_flag=''0'' and (t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

