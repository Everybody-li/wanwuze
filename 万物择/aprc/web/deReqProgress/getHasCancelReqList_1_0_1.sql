-- ##Title web-查询采购需求删除管理
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询采购需求删除管理
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;机构名称(模糊搜索)，非必填
-- ##input startDate string[19] NULL;合同开始日期(格式：0000-00-00)，必填
-- ##input endDate string[19] NULL;合同终止日期(格式：0000-00-00)，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

PREPARE q1 FROM '
select
t1.cattype_guid as cattypeGuid
,t1.cattype_name as cattypeName
,t1.category_guid as categoryGuid
,t1.category_name as categoryName
,t1.category_img as categoryImg
,t1.guid as demandRequestGuid
,t1.user_id as userId
,left(t1.create_time,16) as demandRequestCreateTime
,left(t1.cancel_time,16) as cancelTime
from 
coz_demand_request t1
where 
(t1.cancel_flag=''1'') and t1.del_flag=''0'' and t1.category_guid=''{categoryGuid}''
{dynamic:startDate[and t1.create_time>=''{startDate}'']/dynamic}
{dynamic:endDate[and t1.create_time<=''{endDate}'']/dynamic} 
order by t1.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;