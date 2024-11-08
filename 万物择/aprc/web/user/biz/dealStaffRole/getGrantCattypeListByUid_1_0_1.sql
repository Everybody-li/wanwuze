-- ##Title web-交易专员-查询已保存的品类类型标签设置
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-交易专员-查询已保存的品类类型标签设置
-- ##CallType[QueryData]


-- ##input userId string[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select 
t1.cattype_guid as cattypeGuid
,t2.name as cattypeName
from 
coz_server2_sys_user_cattype t1
inner join
coz_cattype_fixed_data t2
on t1.cattype_guid=t2.guid
where 
t1.del_flag='0' and t2.del_flag='0' and t1.user_id='{userId}'
order by t1.id desc
