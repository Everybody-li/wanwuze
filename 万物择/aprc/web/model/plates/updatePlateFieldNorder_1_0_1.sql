-- ##Title web-修改板块字段名称排序
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-修改板块字段名称排序
-- ##CallType[ExSql]

-- ##input plateFieldGuid char[36] NOTNULL;板块字段名称guid，必填
-- ##input norder int[>=0] NOTNULL;板块类型的顺序，必填
-- ##input newNorder int[>=0] NOTNULL;板块类型顺序，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @categoryGuid=(select category_guid from coz_model_plate_field where guid='{plateFieldGuid}')
;
set @bizType=(select biz_type from coz_model_plate_field where guid='{plateFieldGuid}')
;
set @catTreeCode=(select cat_tree_code from coz_model_plate_field where guid='{plateFieldGuid}')
;
set @flag1=case when((select norder from coz_model_plate_field where guid='{plateFieldGuid}')={norder}) then 1 else 0 end
;
set @norderflag=({newNorder}-{norder})
;

update coz_model_plate_field
set norder=norder-1
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where norder<={newNorder} and norder>={norder} and category_guid=@categoryGuid and biz_type=@bizType and cat_tree_code=@catTreeCode and @norderflag>=0 and guid<>'{plateFieldGuid}' and @flag1=1 and del_flag='0'
;
update coz_model_plate_field
set norder=norder+1
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where norder>={newNorder} and norder<={norder} and category_guid=@categoryGuid and biz_type=@bizType and cat_tree_code=@catTreeCode and @norderflag<=0 and guid<>'{plateFieldGuid}' and @flag1=1 and del_flag='0'
;
update coz_model_plate_field
set norder={newNorder}
,publish_flag='0'
,update_by='{curUserId}'
,update_time=now()
where guid='{plateFieldGuid}' and @flag1=1 and del_flag='0'