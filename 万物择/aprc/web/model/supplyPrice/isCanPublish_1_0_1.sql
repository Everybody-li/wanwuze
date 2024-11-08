-- ##Title web-判断是否可以发布
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-判断是否可以发布
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填

select
case 
when(issupplyplate=1 and issupplyplatefield=1 and iscontentsource=1 and iscontentoperation=1 and isplatefieldcontent=1 and isfixeddata=1 and noInvalidsupplyplate=1) 
then 
1 
else 
0 
end as canPublish
,
case 
when ((issupplyplate=0 or issupplyplatefield=0 or noInvalidsupplyplate=0)) 
then '【供应报价信息配置】未完成，不能发布。'
when (iscontentsource=0 or iscontentoperation=0 or isplatefieldcontent=0) 
then '【字段内容】未配置完整，不能发布。'
when (isfixeddata=0) 
then '【固化字段服务定价基数和报价失效时间】未都配置，不能发布。'
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
case when(exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and del_flag='0')) then 1 else 0 end as issupplyplate

,case when(exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and plate_guid !=''  and del_flag='0')) then 1 else 0 end as issupplyplatefield

,case when(not exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2'  and del_flag='0' and GUID not in(select plate_guid from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and del_flag='0'))) then 1 else 0 end as noInvalidsupplyplate

,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2'  and del_flag='0' and content_source='0')) then 1 else 0 end as iscontentsource
,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2'  and del_flag='0' and operation='0')) then 1 else 0 end as iscontentoperation
,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and (content_source<>'3' and content_source<>'4') and cat_tree_code='supply' and biz_type='2'  and del_flag='0' and GUID not in(select plate_field_guid from coz_model_plate_field_content where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and del_flag='0'))) then 1 else 0 end as isplatefieldcontent
,case when(exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and plate_guid !=''  and del_flag='0' and name in ('f00051','f00062') ) and exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='2' and plate_guid !=''  and del_flag='0' and name='f00053')) then 1 else 0 end as isfixeddata
)t