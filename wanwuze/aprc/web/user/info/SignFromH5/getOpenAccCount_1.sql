-- ##Title 查询报名已开通账号数量
-- ##Author lith
-- ##CreateTime 2026-02-28
-- ##Describe
-- ##CallType[QueryData]

-- ##input phonenumber char[11] NULL;手机号
-- ##input serve_directory_user_guid char[36] NOTNULL;服务主管用户guid

-- ##output num in[>=0] 数量;数量

select
    count(1) as num
from
    coz_serve_signin_record      t1
where
    serve_directory_user_guid = '{curUserId}'
    and user_id <> ''
    {dynamic:phonenumber[and phonenumber like '{phonenumber}']/dynamic}
