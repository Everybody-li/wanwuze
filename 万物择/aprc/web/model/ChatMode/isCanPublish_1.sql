-- ##Title web-发布供需需求信息-判断是否可以发布
-- ##Author lith
-- ##CreateTime 2024-11-17
-- ##Describe web-发布供需需求信息-判断是否可以发布
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid，必填

-- ##input canPublish enum[0,1] NOTNULL;是否可以发布:0-否,1-是
-- ##input notPublishReason string[100] NOTNULL;不可以发布理由



select
case 
when(isdemandplate='1' and  isdemandfixeddata='1' and noInvaliddemandplate='1' and isdemandplatefield='1' and isdemandcontent='1' and issupplyplate='1' and issupplyfixeddata='1' and noInvalidsupplyplate='1' and issupplyplatefield='1' and issupplycontent='1') 
then 
'1'
else 
'0' 
end as canPublish
,
case 
when (isdemandplate<>'1') 
then '采购需求信息未添加任何板块名称。'
when (isdemandfixeddata<>'1') 
then '采购需求信息未添加产品板块名。'
when (noInvaliddemandplate<>'1') 
then concat('采购需求信息的【',noInvaliddemandplate,'】','板块名称下没有字段名称')
when (isdemandplatefield<>'1') 
then concat('采购需求信息的【',isdemandplatefield,'】','字段名称未关联板块名称')
when (isdemandcontent<>'1') 
then concat('采购需求信息的【',isdemandcontent,'】','字段名称未配置完整')
when (issupplyplate<>'1') 
then '供应需求信息未添加任何板块名称。'
when (issupplyfixeddata<>'1') 
then '供应需求信息未添加产品板块名。'
when (noInvalidsupplyplate<>'1') 
then concat('供应需求信息的【',noInvalidsupplyplate,'】','板块名称下没有字段名称')
when (issupplyplatefield<>'1') 
then concat('供应需求信息的【',issupplyplatefield,'】','字段名称未关联板块名称')
when (issupplycontent<>'1') 
then concat('供应需求信息的【',issupplycontent,'】','字段名称未配置完整')
else
''
end as notPublishReason
,
case
when ((select cattype_guid from coz_category_chat_mode where category_guid='{categoryGuid}')='{categoryGuid}')
then
'1'
else
'0'
end as needNewSearch
,(select cattype_guid from coz_category_chat_mode where category_guid='{categoryGuid}') as cattypeGuid
from
(
select 
case when(exists(select 1 from coz_model_chat_plate where category_guid='{categoryGuid}' and cat_tree_code='demand'  and del_flag='0')) then '1' else '0' end as isdemandplate

,ifnull((select alias from coz_model_chat_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and plate_guid ='' and del_flag='0' order by id limit 1),'1') as isdemandplatefield

,ifnull((select alias from coz_model_chat_plate where category_guid='{categoryGuid}' and cat_tree_code='demand'  and del_flag='0' and GUID not in(select plate_guid from coz_model_chat_plate_field where category_guid='{categoryGuid}' and cat_tree_code='demand' and del_flag='0')  order by id limit 1),'1') as noInvaliddemandplate

,case when(exists(select 1 from coz_model_chat_plate where category_guid='{categoryGuid}' and cat_tree_code='supply'  and del_flag='0')) then '1' else '0' end as issupplyplate

,ifnull((select alias from coz_model_chat_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and plate_guid ='' and del_flag='0' order by id limit 1),'1') as issupplyplatefield

,ifnull((select alias from coz_model_chat_plate where category_guid='{categoryGuid}' and cat_tree_code='supply'  and del_flag='0' and GUID not in(select plate_guid from coz_model_chat_plate_field where category_guid='{categoryGuid}' and cat_tree_code='supply' and del_flag='0')  order by id limit 1),'1') as noInvalidsupplyplate

,ifnull((select alias from coz_model_chat_plate_field where category_guid='{categoryGuid}'  and cat_tree_code='demand' and del_flag='0' and (content_source='0' or operation='0' or ((content_source<>3 and content_source<>4)  and GUID not in(select plate_field_guid from coz_model_chat_plate_field_content where category_guid='{categoryGuid}' and cat_tree_code='demand' and del_flag='0'))) order by id limit 1),'1') as isdemandcontent
,ifnull((select alias from coz_model_chat_plate_field where category_guid='{categoryGuid}'  and cat_tree_code='supply' and del_flag='0' and (content_source='0' or operation='0' or ((content_source<>3 and content_source<>4)  and GUID not in(select plate_field_guid from coz_model_chat_plate_field_content where category_guid='{categoryGuid}' and cat_tree_code='supply' and del_flag='0'))) order by id limit 1),'1') as issupplycontent

,case when(exists(select 1 from coz_model_chat_plate where category_guid='{categoryGuid}' and cat_tree_code='demand' and del_flag='0' and (fixed_data_code='p00001'))) then '1' else '0' end as isdemandfixeddata
,case when(exists(select 1 from coz_model_chat_plate where category_guid='{categoryGuid}' and cat_tree_code='supply' and del_flag='0' and (fixed_data_code='p00001'))) then '1' else '0' end as issupplyfixeddata
)t