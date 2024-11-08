-- ##Title web-查询品类别名
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类别名
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output guid char[36] 品类id;品类id
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output alias string[50] 品类别名;品类别名

select
guid
,name as categoryName
,alias
from
coz_category_info t
where 
guid='{categoryGuid}'and del_flag=0
