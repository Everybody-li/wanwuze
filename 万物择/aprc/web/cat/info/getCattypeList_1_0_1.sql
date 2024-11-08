-- ##Title web-查询品类图片通用管理列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类图片通用管理列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t.guid as cattypeGuid
,t.name as cattypeName
,t.img as cattypeImg
from
coz_cattype_fixed_data t
where
t.del_flag='0'
order by norder