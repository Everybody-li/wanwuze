-- ##Title app-查询创建的招聘信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询创建的招聘信息列表
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t2.guid as categoryGuid
,t2.name as categoryName
,t2.alias as categoryAlias
,t2.img as categoryImg
,t1.guid as recruitGuid
,left(t1.create_time,16) as recruitCreateTime
,t1.sales_on as salesOn
from
coz_chat_recruit t1
left join
coz_category_info t2
on t1.category_guid=t2.guid
where 
t1.sd_path_guid=''{sdPathGuid}'' and t1.user_id=''{curUserId}'' and t1.del_flag=''0''
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;
