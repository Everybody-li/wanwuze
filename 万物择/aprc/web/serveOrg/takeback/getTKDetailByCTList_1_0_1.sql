-- ##Title web-查询机构品类权限管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询机构品类权限管理列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;用户id(登录用户id)，必填
-- ##input cattypeGuid char[36] NOTNULL;品类类型guid，必填
-- ##input phonenumber string[11] NULL;服务对象手机号，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t1.object_name as objectName
,t2.nation
,t1.object_phonenumber as phonenumber
from
coz_serve_org_gain_log t1
inner join
coz_app_phonenumber t2
on t1.object_phonenumber=t2.phonenumber
where t1.del_flag=''0'' and t2.del_flag=''0'' and t1.cattype_guid=''{cattypeGuid}'' and t1.takeback_flag=''1'' and t1.free_flag=''0'' and (t1.object_phonenumber like ''%{phonenumber}%'' or t1.object_name like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;

