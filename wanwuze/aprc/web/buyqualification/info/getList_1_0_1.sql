-- ##Title web-查询品类采购资质列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类采购资质列表
-- ##CallType[QueryData]

-- ##input categoryName string[50] NULL;品类名称，非必填
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output qualificationGuid string[50] 品类资质guid;品类资质guid
-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称
-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output publishFlag int[>=0] 0;发布标志（0-未发布，其他数值：已发布）

PREPARE q1 FROM '
select
*
,case when(flag1=''1'' and flag2=''1'' and flag3=''1'') then ''2'' else ''0'' end as publishFlag
,case when(flag1=''1'' and flag2=''1'' and flag3=''1'') then publishTimes else '''' end as publishTime
from
(
select
t.guid as qualificationGuid
,t1.guid as categoryGuid
,t1.name as categoryName
,t1.cattype_name as cattypeName
,t1.id
,case when (not exists (select 1 from coz_model_plate where biz_type=''4'' and category_guid=t1.guid and del_flag=''0'')) then ''0'' when (exists (select 1 from coz_model_plate where biz_type=''4'' and category_guid=t1.guid and publish_flag=''0'')) then ''0'' else ''1'' end as flag1
,case when (not exists (select 1 from coz_model_plate_field where biz_type=''4'' and category_guid=t1.guid and del_flag=''0'')) then ''0'' when (exists (select 1 from coz_model_plate_field where biz_type=''4'' and category_guid=t1.guid and publish_flag=''0'')) then ''0'' else ''1'' end as flag2
,case when (exists (select 1 from coz_model_plate_field_content where biz_type=''4'' and category_guid=t1.guid and publish_flag=''0'')) then ''0'' else ''1'' end as flag3
,left(t.publish_time,19) as publishTimes
from
coz_category_buy_qualification t
left join
coz_category_info t1
on t.category_guid=t1.guid
where
(t1.name like ''%{categoryName}%'' or ''{categoryName}''='''') and t.del_flag=''0''
)t
order by t.id desc
limit ?,?;
';
SET @start =(({page}-1)*{size});
SET @end =({size});
EXECUTE q1 USING @start,@end;