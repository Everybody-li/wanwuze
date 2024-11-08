-- ##Title app-应聘-应聘方式管理-目标工作管理-查看工作信息-字段名称内容值
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe
-- ##CallType[QueryData]

select
fd_guid as fdGuid
,case when (fd_code='c10002') then t1.path_name else fd_value end as value
,case when (fd_code='c10002') then t1.code else '' end as bizValue
from
coz_chat_employ_detail t
left join
sys_city_code t1
on t1.code=t.fd_value
where employ_guid='{recruitGuid}'
;
