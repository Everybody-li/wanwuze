-- ##Title web-服务应用信息-查询已添加的信息名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-服务应用信息-查询已添加的信息名称列表
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;服务对象guid，必填
-- ##input type string[1] NOTNULL;类型（1：沟通话术，2：服务话术）必填
-- ##input dataType string[1] NOTNULL;类型（1：沟通话术，2：服务话术）必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input labelData string[50] NULL;标签名称数据值

PREPARE q1 FROM '
select 
t2.guid as dataGuid
,t2.name as labelData
,case when exists(select 1 from coz_server2_sys_user_label where del_flag=''0'' and user_id=''{targetUserId}'' and type=''{type}'' and data_guid=t2.guid) then ''1'' else ''0'' end as selectedFlag
from
coz_serve2_bizdict t2
where t2.del_flag=''0'' and t2.type=''{dataType}'' and (t2.name  like ''%{labelData}%'' or ''{labelData}''='''')
order by t2.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;