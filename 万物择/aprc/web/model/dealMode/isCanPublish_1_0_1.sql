-- ##Title web-发布供需需求信息-判断是否可以发布
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-发布供需需求信息-判断是否可以发布
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填

select
case 
when(isdemandplate=1 and  isdemandplatefield=1 and issupplyplate=1 and issupplyplatefield=1 and noInvaliddemandplate=1 and noInvalidsupplyplate=1 and iscontentsource=1 and iscontentoperation=1 and isplatefieldcontent=1 and isfixeddata=1) 
then 
1 
else 
0 
end as canPublish
,
case 
when ((isdemandplate=0 or  isdemandplatefield=0 or noInvaliddemandplate=0) and (issupplyplate=0 or issupplyplatefield=0 or noInvalidsupplyplate=0)) 
then '【采购需求信息配置】,【供应需求信息配置】未完成，不能发布。'
when (isdemandplate=0 or  isdemandplatefield=0 or noInvaliddemandplate=0) 
then '【采购需求信息配置】未完成，不能发布。'
when (issupplyplate=0 or issupplyplatefield=0 or noInvalidsupplyplate=0) 
then '【供应需求信息配置】未完成，不能发布。'
when (iscontentsource=0 or iscontentoperation=0 or isplatefieldcontent=0) 
then '【字段内容】未配置完整，不能发布。'
when (isfixeddata=0) 
then '【产品板块】未配置，不能发布。'
else
''
end as notPublishReason
,
case
when ((select cattype_guid from coz_category_deal_mode where category_guid='{categoryGuid}')='{categoryGuid}')
then
'1'
else
'0'
end as needNewSearch
,(select cattype_guid from coz_category_deal_mode where category_guid='{categoryGuid}') as cattypeGuid
from
(
select 
case when(exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='1'  and del_flag='0')) then 1 else 0 end as isdemandplate

,case when(exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='1' and plate_guid !=''  and del_flag='0')) then 1 else 0 end as isdemandplatefield

,case when(not exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='1'  and del_flag='0' and GUID not in(select plate_guid from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='1' and del_flag='0'))) then 1 else 0 end as noInvaliddemandplate

,case when(exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='1'  and del_flag='0')) then 1 else 0 end as issupplyplate


,case when(exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='1' and plate_guid !=''  and del_flag='0')) then 1 else 0 end as issupplyplatefield

,case when(not exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='1'  and del_flag='0' and GUID not in(select plate_guid from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and biz_type='1' and del_flag='0'))) then 1 else 0 end as noInvalidsupplyplate

,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}'and biz_type='1'  and del_flag='0' and content_source=0)) then 1 else 0 end as iscontentsource
,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}'and biz_type='1'  and del_flag='0' and operation=0)) then 1 else 0 end as iscontentoperation
,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and (content_source<>3 and content_source<>4) and biz_type='1'  and del_flag='0' and GUID not in(select plate_field_guid from coz_model_plate_field_content where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='1' and del_flag='0'))) then 1 else 0 end as isplatefieldcontent

,case when(exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and biz_type='1' and del_flag='0' and (fixed_data_code='p00001'))) then 1 else 0 end as isfixeddata
)t