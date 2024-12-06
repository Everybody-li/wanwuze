-- ##Title web-询价专员-查询已保存的品类标签设置-品类类型数量统计部分
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-询价专员-查询已保存的品类标签设置-品类类型数量统计部分
-- ##CallType[QueryData]

-- ##input userId string[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select 
t1.cattype_guid as cattypeGuid
,t2.name as cattypeName
,count(1) as categoryNum
from 
coz_category_info t1
inner join
coz_cattype_fixed_data t2
on t1.cattype_guid=t2.guid
left join
coz_server2_sys_user_category t3
on t1.guid=t3.category_guid
where 
t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0' and t3.user_id='{userId}'
group by t1.cattype_guid,t2.name,t2.norder
order by t2.norder desc