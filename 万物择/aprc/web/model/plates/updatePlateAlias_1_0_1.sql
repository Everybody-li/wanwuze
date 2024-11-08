-- ##Title web-编辑板块别名
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-编辑板块别名
-- ##CallType[ExSql]

-- ##input plateGuid char[36] NOTNULL;板块guid，必填
-- ##input plateAlias string[50] NOTNULL;板块别名，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


set @categoryGuid=(select category_guid from coz_model_plate where guid='{plateGuid}')
;
set @bizType=(select biz_type from coz_model_plate where guid='{plateGuid}')
;
set @cat_tree_code=(select cat_tree_code from coz_model_plate where guid='{plateGuid}')
;
set @Flag4=case when(exists(select 1 from coz_model_plate where category_guid=@categoryGuid and biz_type=@bizType and cat_tree_code=@cat_tree_code and del_flag='0' and alias='{plateAlias}')) then '0' else '1' end
;
update coz_model_plate
set alias='{plateAlias}'
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateGuid}' and @Flag4='1'