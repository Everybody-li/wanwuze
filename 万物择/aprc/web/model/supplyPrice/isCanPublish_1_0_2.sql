-- ##Title web-判断是否可以发布
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-判断是否可以发布
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填

select
case 
when(issupplyplate='1' and issupplyplatefield='1' and noInvalidsupplyplate='1' and isplatefieldcontent='1' and isfixeddata='1') 
then 
1 
else 
0 
end as canPublish
,
case 
when (issupplyplate<>'1') 
then '未添加任何板块名称。'
when (noInvalidsupplyplate<>'1') 
then concat('【',noInvalidsupplyplate,'】','板块名称下没有字段名称')
when (issupplyplatefield<>'1') 
then concat('【',issupplyplatefield,'】','字段名称未关联板块名称')
when (isplatefieldcontent<>'1') 
then concat('【',isplatefieldcontent,'】','字段名称未配置完整')
when (isfixeddata<>'1') 
then '“固化字段名称服务定价基数或报价失效时间”未添加'
else
''
end as notPublishReason
,
case
when exists(select 1 from coz_cattype_fixed_data where guid=(select category_guid from coz_category_deal_mode where category_guid='{categoryGuid}'))
then
'1'
else
'0'
end as needNewSearch
,(select guid from coz_cattype_fixed_data where guid=(select category_guid from coz_category_deal_mode where category_guid='{categoryGuid}')) as cattypeGuid
from
(
select 
case when(exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and del_flag='0')) then '1' else '0' end as issupplyplate

,ifnull((select alias from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and plate_guid =''  and del_flag='0' order by id limit 1),'1') as issupplyplatefield

,ifnull((select alias from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2'  and del_flag='0' and GUID not in(select plate_guid from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and del_flag='0')  order by id limit 1),'1') as noInvalidsupplyplate

,ifnull((select alias from coz_model_plate_field where category_guid='{categoryGuid}'and biz_type='2' and cat_tree_code='supply' and del_flag='0' and (content_source='0' or operation='0' or ((content_source<>3 and content_source<>4)  and GUID not in(select plate_field_guid from coz_model_plate_field_content where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and del_flag='0'))) order by id limit 1),'1') as isplatefieldcontent

,case when(exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and plate_guid !=''  and del_flag='0' and name in ('f00051','f00062') ) and exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and plate_guid !=''  and del_flag='0' and name='f00053')) then '1' else '0' end as isfixeddata
)t