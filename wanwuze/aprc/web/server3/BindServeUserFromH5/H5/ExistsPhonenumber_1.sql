-- ##Title 服务专员H5报名
-- ##Author lith
-- ##CreateTime 2026-02-28
-- ##Describe 新增关联关系
-- ##CallType[QueryData]

-- ##input phonenumber char[11] NOTNULL;手机号

-- ##output existsFlag enum[0,1] 是否存在;0-否，1-是


select
    if(count(1)=0,0,1) as existsFlag
from
    coz_serve3_signin_record
where
    phonenumber = '{phonenumber}'