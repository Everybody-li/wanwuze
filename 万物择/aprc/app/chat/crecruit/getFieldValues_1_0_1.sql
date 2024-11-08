-- ##Title app-查询招聘页面字段内容候选项值
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询招聘页面字段内容候选项值
-- ##CallType[QueryData]

select
fd_guid as fdGuid
,case when (fd_code='c10002') then t1.path_name else fd_value end as value
,case when (fd_code='c10002') then t1.code else '' end as bizValue
from
coz_chat_recruit_detail t
left join
sys_city_code t1
on t1.code=t.fd_value
where recruit_guid='{recruitGuid}'
;
