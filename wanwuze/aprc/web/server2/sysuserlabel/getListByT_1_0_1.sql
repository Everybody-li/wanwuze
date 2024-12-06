-- ##Title web-服务应用信息-查询已添加的信息名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务应用信息-查询已添加的信息名称列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;服务对象guid，必填
-- ##input dataGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input phonenumber string[11] NULL;姓名或联系电话（模糊搜索），非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t1.user_id as userId
,t1.user_name as userName
,t1.nick_name as nickName
,concat(''(+86)'',t1.phonenumber) as phonenumber
from
coz_server2_sys_user_label dt2
inner join
coz_server2_sys_user_label dt6
on dt2.user_id=dt6.user_id
inner join
sys_user t1
on dt2.user_id=t1.user_id
inner join
sys_user_role t2
on t1.user_id=t2.user_id
inner join
sys_role t3
on t2.role_id=t3.role_id
where dt2.data_type=''2'' and dt6.data_type=''6'' and dt2.data_guid=''{dataGuid}'' and dt6.data_guid=''{sdPathGuid}'' and dt2.del_flag=''0''and dt6.del_flag=''0''and t1.status=''0'' and t1.del_flag=''0'' and (t1.user_name like ''%{phonenumber}%'' or t1.phonenumber like ''%{phonenumber}%'' or ''{phonenumber}''='''') and t3.role_key=''commuStaffRole''
order by dt2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;