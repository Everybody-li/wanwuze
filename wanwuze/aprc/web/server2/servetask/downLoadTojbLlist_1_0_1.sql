-- ##Title web-导出沟通用户列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-导出沟通用户列表
-- ##CallType[QueryData]

-- ##input phonenumber string[11] NULL;机构名称(模糊搜索)，非必填
-- ##input commuTaskGuid string[36] NOTNULL;沟通任务guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t2.name as 姓名
,concat('(+86)',t2.phonenumber) as 沟通专员联系电话
,t3.org_name as 机构名称
,t3.r_type as 角色类型
,t3.org_type as 机构类型
,t3.register_city as 注册区域
from 
coz_serve2_commu_task_tobject t1
inner join
coz_target_object t2
on t1.object_guid=t2.guid
inner join
coz_target_object_org t3
on t1.object_org_guid=t3.guid
where 
(t2.phonenumber like'%{phonenumber}%' or t3.org_name like'%{phonenumber}%' or '{phonenumber}'='') and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and (t1.commu_task_guid='{commuTaskGuid}' or '{commuTaskGuid}'='')
order by t2.id desc,t3.id desc
