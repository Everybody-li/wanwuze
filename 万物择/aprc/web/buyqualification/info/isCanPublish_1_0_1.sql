-- ##Title web-发布采购资质信息-判断是否可以发布
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-发布采购资质信息-判断是否可以发布
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
case 
when(isdemandplate=1 and isdemandplatefield=1 and noInvaliddemandplate=1 and iscontentsource=1 and iscontentoperation=1 and isplatefieldcontent=1) 
then 
1 
else 
0 
end as canPublish
,
case 
when (isdemandplate=0 or isdemandplatefield=0 or noInvaliddemandplate=0) 
then '【采购资质信息管理】未配置完整，不能发布。'
when (iscontentsource=0 or iscontentoperation=0 or isplatefieldcontent=0) 
then '【字段内容】未配置完整，不能发布。'
else
''
end as notPublishReason
from
(
select 
case when(exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='4'  and del_flag='0')) then 1 else 0 end as isdemandplate
,case when(exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='4' and plate_guid !=''  and del_flag='0')) then 1 else 0 end as isdemandplatefield
,case when(not exists(select 1 from coz_model_plate where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='4'  and del_flag='0' and GUID not in(select plate_guid from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='4' and del_flag='0'))) then 1 else 0 end as noInvaliddemandplate
,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='4'  and del_flag='0' and content_source=0)) then 1 else 0 end as iscontentsource
,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='4'  and del_flag='0' and operation=0)) then 1 else 0 end as iscontentoperation
,case when(not exists(select 1 from coz_model_plate_field where category_guid='{categoryGuid}' and (content_source<>3 and content_source<>4) and biz_type='4'  and del_flag='0' and GUID not in(select plate_field_guid from coz_model_plate_field_content where category_guid='{categoryGuid}' and cat_tree_code='demand' and biz_type='4' and del_flag='0'))) then 1 else 0 end as isplatefieldcontent
)t