-- ##Title web-服务主管操作管理-服务主管团队管理-查询服务专员关联记录列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 查询当前服务主管关联的服务专员关联记录列表
-- ##Describe 表名：coz_server3_sys_user_dj_bind_log t1,sys_user_extra,sys_user
-- ##CallType[QueryData]

-- ##input targetUserId char[36] NOTNULL;目标用户id(服务主管用户id)
-- ##input phonenumber string[30] NULL;姓名或者联系电话(模糊搜索)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>0] NOTNULL;第几页（默认1）
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output bindTime char[19] 2023-12-12 12:12:12;关联日期
-- ##output bindStatus enum[关联,解除关联] ;状态
-- ##output userName string[30] ;账号名称
-- ##output registerTime char[19] 2023-12-12 12:12:12;账号开通日期
-- ##output nickName char[19] ;姓名
-- ##output phonenumber char[15] ;联系电话
-- ##output workNo char[19] ;工号


select subl.create_time                                      as bindTime,
       case
           when subl.unbind_type is null then '关联'
           when subl.unbind_type is not null then '解除关联' end as bindStatus,
       su.user_name                                          as userName,
       left(su.create_time, 16)                              as registerTime,
       su.nick_name                                          as nickName,
       nation                                                as nation,
       concat('(+86)', phonenumber)                          as phonenumber,
       sue.ex_value                                          as workNo
from sys_user su
         inner join coz_server3_sys_user_bind_log subl on su.user_id = subl.bind_suser_guid
         inner join sys_user_extra sue on su.user_id = sue.user_guid
where subl.binded_suser_guid = '{targetUserId}'
  and sue.ex_key = 1
   {dynamic:phonenumber[and (su.nick_name like '%{phonenumber}%' or su.phonenumber like '%{phonenumber}%')]/dynamic}
order by subl.create_time desc
    Limit {compute:[({page}-1)*{size}]/compute},{size};