-- ##Title 查询报名未开通账号数量
-- ##Author lith
-- ##CreateTime 2026-02-28
-- ##Describe
-- ##CallType[QueryData]

-- ##input phonenumber char[11] NULL;手机号
-- ##input serve_directory_user_guid char[36] NULL;服务主管用户guid


-- ##output num in[>=0] 数量;数量

select
    count(1) as num
from
    coz_serve_signin_record      t1
where
    user_id = ''
    {dynamic:serve_directory_user_guid[and  serve_directory_user_guid = '{serve_directory_user_guid}']/dynamic}
    {dynamic:phonenumber[and phonenumber like '{phonenumber}']/dynamic}
