-- ##Title 查询报名未开通账号列表
-- ##Author lith
-- ##CreateTime 2026-02-28
-- ##Describe 新增关联关系
-- ##CallType[QueryData]


-- ##input phonenumber char[11] NULL;手机号
-- ##input serve_directory_user_guid char[36] NOTNULL;服务主管用户guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>=0] NOTNULL;第几页（默认1）

-- ##output username string[100] 姓名;姓名
-- ##output phonenumber char[11] 手机号;手机号
-- ##output nation string[100] 国家/地区;国家/地区
-- ##output create_time string[19] 报名时间;报名时间
-- ##output path_name string[100] 所处区域;所处区域


select
    t1.`name` as username
  , t1.phonenumber
  , t1.nation
  , t1.create_time
  , t2.path_name
from
    coz_serve_signin_record      t1
    inner join
        `apro-rec`.sys_city_code t2 on t1.sys_city_code = t2.code
where
    serve_directory_user_guid = '{serve_directory_user_guid}'
    and user_id = ''
    {dynamic:phonenumber[and phonenumber like '{phonenumber}']/dynamic}
Limit {compute:[({page}-1)*{size}]/compute},{size};
