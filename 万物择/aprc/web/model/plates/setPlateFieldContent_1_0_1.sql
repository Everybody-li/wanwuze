-- ##Title web-添加字段内容（固化库/自建库）
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-添加字段内容（固化库/自建库）
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;字段名称guid，必填
-- ##input content string[200] NOTNULL;字段内容，多个内容多条记录,批量保存（固化库的时候传固化库的fixedDataGuid,自建库的时候传自建内容值），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_model_plate_field_content(guid,cattype_guid,cat_tree_code,category_guid,biz_type,plate_field_guid,content,publish_flag,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,cattype_guid
,cat_tree_code
,category_guid
,biz_type
,'{plateFieldGuid}'
,'{content}'
,'0'
,'0'
,'-1'
,now()
,'-1'
,now()
from
coz_model_plate_field
where not exists(select 1 from coz_model_plate_field_content where plate_field_guid='{plateFieldGuid}' and content='{content}' and del_flag='0') and guid='{plateFieldGuid}'
;