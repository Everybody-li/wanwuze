-- ##Title app-供应-查询某一品类下的采购需求接收需求信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-供应-查询某一品类下的采购需求接收需求信息列表
-- ##CallType[QueryData]

-- ##input supplyPathGuid char[36] NOTNULL;供应路径guid，必填
-- ##input categoryGuid char[36] NOTNULL;供应路径guid，必填
-- ##input recommedType string[1] NOTNULL;推荐类型（1-严格匹配规则推荐，2-系统推荐），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填

PREPARE q1 FROM '
select
t.request_guid as requestGuid
,t.guid as matchNoticeGuid
,t.recommend_type as recommedType
,left(t.create_time,16) as mtNeCreateTime
,t1.category_guid as categoryGuid
,t1.category_name as categoryName
,t1.category_img as categoryImg
,t1.category_alias as categoryAlias
from 
coz_demand_request_match_notice t
inner join
coz_demand_request t1
on t.request_guid=t1.guid
where 
t.supply_path_guid=''{supplyPathGuid}'' and t.user_id=''{curUserId}'' and t.recommend_type=''{recommedType}'' and t.del_flag=''0'' and t1.category_guid=''{categoryGuid}''
order by t.create_time desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;