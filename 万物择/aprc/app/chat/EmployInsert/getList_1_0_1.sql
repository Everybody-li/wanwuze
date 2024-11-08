-- ##Title app-应聘-应聘方式管理-目标工作管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

-- ##output categoryGuid char[36] 品类名称guid;
-- ##output categoryName string[50] 品类名称;
-- ##output categoryImg string[50] 品类名称图片;
-- ##output categoryAlias string[50] 品类名称别名;
-- ##output recruitGuid char[36] 招聘信息Guid;
-- ##output recruitCreateTime string[16] 0000-00-00 00:00;t1的创建日期(0000-00-00 00:00)
-- ##output salesOn string[1] 1;上下架状态(1：上架，2：下架)

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
coz_chat_employ t1
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
