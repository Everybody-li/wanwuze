-- ##Title app-(新增)完善采购资质
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-(新增)完善采购资质
-- ##CallType[ExSql]

-- ##input qualificationUserGuid char[36] NOTNULL;供方品类表guid（app自己生成uuid），必填
-- ##input qualificationLogGuid char[36] NOTNULL;品类资质最新已发布的guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input userId string[36] NOTNULL;需方用户id，必填

insert into coz_category_buy_qualification_user(guid,category_guid,qualification_log_guid,user_id,del_flag,create_by,create_time,update_by,update_time)
select
'{qualificationUserGuid}'
,'{categoryGuid}'
,'{qualificationLogGuid}'
,'{userId}'
,'0'
,'-1'
,now()
,'-1'
,now()
;
