-- ##Title app-多选-查询多选操作后回到主业务页面的行政区域数据列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-多选-查询多选操作后回到主业务页面的行政区域数据列表
-- ##CallType[QueryData]

-- ##input bizGuid string[36] NOTNULL;业务guid，必填
-- ##input bizCode string[30] NOTNULL;父级code，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.path_name  as nodePathName
,t1.code as nodeCode
from 
sys_city_code t1
inner join
coz_biz_city_code_temp t2
on t1.code=t2.ncode
where t2.biz_guid= '{bizGuid}' and t2.active_flag='0'
order by t1.id;

