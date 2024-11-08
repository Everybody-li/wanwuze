-- ##Title 获取获取失败失败的用户列表
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 获取获取失败失败的用户列表
-- ##CallType[QueryData]

-- ##input userId char[36] NOTNULL;用户id
-- ##input batchNumber char[36] NULL;批次号

-- ##output phonenumber string[30] 领取失败用户手机号;领取失败用户手机号
-- ##output createTime string[19] 被领取日期;被领取日期
-- ##output userName string[30] 用户姓名;用户姓名

select 
t.phonenumber
,t.create_time as ReceiveTime
,t1.user_name as userName
from
coz_guidance_user_record t
left join
sys_app_user t1
on t.user_id=t1.guid
where t.phonenumber in({phonenumber}) and t.create_by='{batchNumber}'
-- and left(now(),10)!=left(t.create_time,10)