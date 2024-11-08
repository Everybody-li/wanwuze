-- ##Title app-查询系统用户(可领取)服务对象列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-查询系统用户(可领取)服务对象列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NULL;用户手机号，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填


PREPARE q1 FROM '
select 
t1.guid as freeUserGuid
,t1.user_id as userId 
,t1.remark_username as username
,t1.phonenumber
,replace(t1.nation,''中国大陆'','''') as nation
,t1.remark_username as userName
from
coz_guidance_free_user t1
where
t1.user_id!=''{curUserId}''and t1.del_flag=''0'' and (t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''')
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;