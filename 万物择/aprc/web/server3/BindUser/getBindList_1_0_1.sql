-- ##Title web-运营专员操作管理-运营用户管理-服务专员用户管理-查询当前关联服务主管列表
-- ##Author 卢文彪
-- ##CreateTime 2023-12-19
-- ##Describe 新增关联关系
-- ##Describe 表名: coz_server3_sys_user_bind,coz_server3_sys_user_bind_log
-- ##CallType[QueryData]

-- ##input userGuid char[36] NOTNULL;服务专员guid
-- ##input page int[>0] NOTNULL;第几页
-- ##input size int[>0] NOTNULL;每页数量
-- ##input curUserId char[36] NOTNULL;登录用户id

-- ##output userName string[30] ;账号名称
-- ##output registerTime char[19] 2023-12-12 12:12:12;账号创建日期
-- ##output nickName char[19] ;姓名
-- ##output nation char[9] 中国大陆（+86）;国家/区号
-- ##output phonenumber char[11] ;联系电话
-- ##output bindTime char[19] 2023-12-12 12:12:12;关联日期
-- ##output bindGuid char[36] bindGuid;bindGuid

select su.user_name     as userName,
       su.create_time   as registerTime,
       su.nick_name     as nickName,
       nation           as nation,
       phonenumber      as phonenumber,
       sub.create_time as bindTime,
       sub.guid as bindGuid
from sys_user su
         inner join coz_server3_sys_user_bind sub on su.user_id = sub.binded_suser_guid
where sub.bind_suser_guid = '{userGuid}' and su.del_flag = '0'
order by sub.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size}
;