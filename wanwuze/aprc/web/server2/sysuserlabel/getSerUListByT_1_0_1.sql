-- ##Title web-服务应用信息-查询已添加的信息名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务应用信息-查询已添加的信息名称列表
-- ##CallType[QueryData]

-- ##input phonenumber string[50] NULL;姓名或者联系电话(模糊搜索)，非必填
-- ##input sdPathGuid char[36] NOTNULL;服务对象guid，必填
-- ##input data2Guid char[36] NOTNULL;服务对象guid，必填
-- ##input data4Guid char[36] NOTNULL;服务对象guid，必填
-- ##input data5Guid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select 
t2.user_id as userId
,t2.user_name as userName
,t2.nick_name as nickName
,concat(''(+86)'',t2.phonenumber) as phonenumber
from
(
select
user_id,id
from
(
select dt2.user_id,dt2.id from coz_server2_sys_user_label dt2 inner join coz_server2_sys_user_label dt4 on dt2.user_id=dt4.user_id and dt2.data_type=''2'' and dt4.data_type=''4'' inner join coz_server2_sys_user_label dt5 on dt2.user_id=dt5.user_id and dt2.data_type=''2'' and dt5.data_type=''5'' inner join coz_server2_sys_user_label dt6 on dt2.user_id=dt6.user_id and dt2.data_type=''2'' and dt6.data_type=''6'' where dt2.data_guid=''{data2Guid}'' and dt4.data_guid=''{data4Guid}'' and dt5.data_guid=''{data5Guid}'' and dt6.data_guid=''{sdPathGuid}'' and dt2.del_flag=''0'' and dt4.del_flag=''0'' and dt5.del_flag=''0'' and dt6.del_flag=''0''
)t
group by user_id,id
) t1
inner join
sys_user t2
on t1.user_id=t2.user_id
inner join
sys_user_role t3
on t2.user_id=t3.user_id
inner join
sys_role t4
on t3.role_id=t4.role_id
where t2.del_flag=''0'' and t2.status=''0'' and (t2.user_name like ''%{phonenumber}%''or t2.phonenumber like ''%{phonenumber}%''or  ''{phonenumber}'' = '''') and t4.role_key=''serveStaffRole''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;