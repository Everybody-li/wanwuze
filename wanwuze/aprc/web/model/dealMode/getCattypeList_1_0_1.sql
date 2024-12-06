-- ##Title web-查询品类类型通用供需需求信息列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询品类类型通用供需需求信息列表
-- ##CallType[QueryData]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填


-- ##output categoryGuid string[50] 品类guid;品类guid
-- ##output categoryName string[50] 品类名称;品类名称
-- ##output cattypeName string[50] 品类类型名称;品类类型名称

-- ##output publishTime string[19] 最新发布时间;最新发布时间（格式：0000年00月00日 00:00）
-- ##output publishFlag int[>=0] 0;发布标志（0-未发布，其他数值：已发布）
-- ##output createTime string[19] 创建时间;创建时间（格式：0000-00-00 00:00:00）

select
*
,case when(flag1='1' and flag2='1' and flag3='1') then '2' else '0' end as publishFlag
,case when(flag1='1' and flag2='1' and flag3='1') then publishTimes else '' end as publishTime
from
(
select
t1.guid as categoryGuid
,t1.name as categoryName
,t1.name as cattypeName
,t1.norder
,case when (not exists (select 1 from coz_model_plate where biz_type='1' and category_guid=t1.guid and del_flag='0')) then '0' when (exists (select 1 from coz_model_plate where biz_type='1' and category_guid=t1.guid and publish_flag='0')) then '0' else '1' end as flag1
,case when (not exists (select 1 from coz_model_plate_field where biz_type='1' and category_guid=t1.guid and del_flag='0')) then '0' when (exists (select 1 from coz_model_plate_field where biz_type='1' and category_guid=t1.guid and publish_flag='0')) then '0' else '1' end as flag2
,case when ((exists(select 1 from coz_model_plate_field where biz_type='1' and category_guid=t1.guid and del_flag='0' and (operation='1' or operation='2'))) and (not exists (select 1 from coz_model_plate_field_content where biz_type='1' and category_guid=t1.guid and del_flag='0'))) then '0' when (exists (select 1 from coz_model_plate_field_content where biz_type='1' and category_guid=t1.guid and publish_flag='0')) then '0' else '1' end as flag3
,left(t.publish_time,19) as publishTimes
from
coz_cattype_fixed_data t1
inner join
coz_category_deal_mode t
on t.category_guid=t1.guid
where
t1.del_flag='0' and t1.mode=2
)t
order by t.norder
