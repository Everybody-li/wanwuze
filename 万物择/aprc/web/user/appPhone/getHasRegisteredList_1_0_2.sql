-- ##Title web-查询机构被授权的品类列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询机构被授权的品类列表
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
,t1.name as userName
,t2.guid as userId
,(select count(1) from coz_order where demand_user_id=t1.user_id and accept_status=''1'' and del_flag=''0'') as orderNum
from
coz_target_object t1
inner join
sys_app_user t2
on t1.phonenumber=t2.phonenumber
where t1.del_flag=''0'' and t2.del_flag=''0'' and (t2.user_name like ''%{phonenumber}%'' or t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''') and t1.user_id<>''a''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE p1 USING @start,@end;

