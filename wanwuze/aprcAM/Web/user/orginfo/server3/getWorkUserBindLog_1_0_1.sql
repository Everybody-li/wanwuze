-- ##Title web-运营专员操作管理-供应机构管理-供应机构信息管理-关联对接专员管理-查询对接专员关联记录
-- ##Author 卢文彪
-- ##CreateTime 2023-09-07
-- ##Describe 查询机构用户的对接专员关联记录,关联日期:关联类型是绑定时的创建日期.取消关联日期:关联类型是解绑时的创建日期.
-- ##Describe 表名： sys_user t1,coz_server3_sys_user_dj_bind_log t2
-- ##CallType[QueryData]

-- ##input orgUserId char[36] NOTNULL;机构用户id(供方用户id)
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output userName string[30] 账号名称;账号名称
-- ##output createTime string[16] 账号创建日期;账号创建日期
-- ##output nickName string[30] 姓名;姓名
-- ##output nation string[30] 国家/区域;国家/区域
-- ##output phonenumber string[30] 手机号;手机号
-- ##output bindTime string[16] 关联日期;关联日期
-- ##output unbindTime string[16] 取消关联日期;取消关联日期

select 
t1.user_name as userName
,left(t1.create_time,16) as createTime
,t1.nick_name as nickName
,t1.nation
,t1.phonenumber
     , t2.create_time as bindTime
     , t3.create_time as unbindTime
from sys_user t1
         inner join coz_server3_sys_user_dj_bind_log t2
                    on t1.user_id = t2.user_guid and t2.bind_type = '1'
         left join coz_server3_sys_user_dj_bind_log t3 on t2.bind_guid = t3.bind_guid and t3.bind_type = '2'
where 
  t2.binded_user_id='{orgUserId}'
order by t1.create_time desc