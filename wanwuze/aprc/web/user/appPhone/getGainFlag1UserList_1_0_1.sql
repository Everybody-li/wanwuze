-- ##Title web-服务专员用户-查询服务专员列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务专员用户-查询服务专员列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input phonenumber string[50] NULL;姓名或手机号（模糊搜索)，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE p1 FROM '
select
left(t2.create_time,16) as registerTime
,t1.nation
,t1.phonenumber
,t2.user_name as userName
,t2.guid as userId
from
coz_app_phonenumber t1
left join
sys_app_user t2
on t1.phonenumber=t2.phonenumber
where t1.del_flag=''0'' and t2.del_flag=''0'' and t1.gain_flag=''1'' and (t2.user_name like ''%{phonenumber}%'' or t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

