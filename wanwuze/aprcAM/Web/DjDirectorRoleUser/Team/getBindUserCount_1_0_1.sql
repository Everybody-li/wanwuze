-- ##Title web-服务主管操作管理-服务主管团队管理-查询列表-列表上部分-服务专员-括号内数量
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管关联的服务专员数量
-- ##Describe 表名：coz_server3_sys_user_dj_bind_log t1,sys_user
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input phonenumber string[30] NULL;姓名或者联系电话(模糊搜索)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output totalCount int[>=0] ;总计关联的服务专员数量


select count(sub.id) as totalCount
from sys_user su
         inner join coz_server3_sys_user_bind sub on su.user_id = sub.bind_suser_guid
where sub.binded_suser_guid = '{targetUserId}'
  and su.del_flag = '0'
  {dynamic:phonenumber[and (su.nick_name like '%{phonenumber}%' or su.phonenumber like '%{phonenumber}%')]/dynamic}