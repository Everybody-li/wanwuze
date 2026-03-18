-- ##Title 查询报名未开通账号列表
-- ##Author lith
-- ##CreateTime 2026-02-28
-- ##Describe 新增关联关系
-- ##CallType[QueryData]


-- ##input phonenumber char[11] NULL;手机号
-- ##input serve_directory_user_guid char[36] NULL;服务主管用户guid
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
    coz_serve3_signin_record      t1
    inner join
        `apro-rec`.sys_city_code t2  on t1.sys_city_code = t2.code
where
    user_id = ''
   and ('{serve_directory_user_guid}' = 'e294f602-9351-11ed-ad4d-00163e2ca549' or
     ('e294f602-9351-11ed-ad4d-00163e2ca549' <> '{serve_directory_user_guid}' and serve_directory_user_guid = '{serve_directory_user_guid}')
         )    {dynamic:phonenumber[and phonenumber like '{phonenumber}']/dynamic}
Limit {compute:[({page}-1)*{size}]/compute},{size};



select
    t1.`name` as username
  , t1.phonenumber
  , t1.nation
  , t1.create_time
  , t2.path_name,t1.serve_directory_user_guid
from
    coz_serve3_signin_record      t1
    inner join
        `apro-rec`.sys_city_code t2  on t1.sys_city_code = t2.code
where
    user_id = ''
   and ('23dfe79d-d668-11f0-b8a2-00163e30a13f' = 'e294f602-9351-11ed-ad4d-00163e2ca549' or
     ('e294f602-9351-11ed-ad4d-00163e2ca549' <> '23dfe79d-d668-11f0-b8a2-00163e30a13f' and serve_directory_user_guid = '23dfe79d-d668-11f0-b8a2-00163e30a13f')
         )    {dynamic:phonenumber[and phonenumber like '{phonenumber}']/dynamic}
Limit {compute:[({page}-1)*{size}]/compute},{size};

select
    *
from
    sys_user
where user_id= 'a7bfaab8-d668-11f0-b8a2-00163e30a13f'