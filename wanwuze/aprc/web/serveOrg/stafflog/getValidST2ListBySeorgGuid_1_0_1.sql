-- ##Title web-查询服务机构-供应专员团队列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-查询服务机构-供应专员团队列表
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NULL;服务对象手机号，必填
-- ##input seorgGuid char[36] NOTNULL;结算机构guid，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE p1 FROM '
select
t2.user_name as userName
,t2.nick_name as nickName
,t2.nation
,t2.phonenumber
,left(t2.create_time,16) as registerTime
,left(t1.create_time,16) as relateTime
from
coz_serve_org_relate_staff t1
inner join
sys_user t2
on t1.staff_user_id=t2.user_id
where
t1.seorg_guid=''{seorgGuid}'' and t1.staff_type=''2'' and t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.user_name like ''%{phonenumber}%'' or t2.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;