-- ##Title web-查询目标用户选择列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询目标用户选择列表
-- ##CallType[QueryData]

-- ##input orgName string[60] NULL;机构名称(模糊搜索)，非必填
-- ##input orgType string[30] NOTNULL;机构类型名称，必填
-- ##input registerCity string[30] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input roleType string[30] NOTNULL;角色类型名称，非必填
-- ##input needCount int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select 
concat(''(+86)'',t2.phonenumber) as 服务对象联系电话
,t2.name as 姓名
,t1.org_name as 机构名称
,t1.r_type as 角色类型
,t1.org_type as 机构类型
,t1.register_city as 注册区域
from
coz_target_object_org t1
inner join
coz_target_object t2
on t2.guid=t1.object_guid
where 
(t1.org_name like''%{orgName}%'' or ''{orgName}''='''') and t1.del_flag=''0'' and t1.org_type=''{orgType}'' and t1.register_city=''{registerCity}'' and t1.r_type=''{roleType}''
order by t1.id desc
limit ?,?;
';
SET @start =(1*{needCount});
SET @end =({needCount});
EXECUTE q1 USING @start,@end;