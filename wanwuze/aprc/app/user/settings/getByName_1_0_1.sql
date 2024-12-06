-- ##Title app-招聘方/应聘方-查询系统推荐设置
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 
-- ##CallType[QueryData]

-- ##input name enum[cderequest_auto_recommend,csurequest_auto_recommend] NOTNULL;设置字段名称(cderequest_auto_recommend:招聘方系统推荐设置,csurequest_auto_recommend:应聘聘方系统推荐设置)
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.value
from  
coz_user_biz_settings t1
where 
t1.name='{name}' and t1.user_id='{curUserId}' and t1.del_flag='0'

