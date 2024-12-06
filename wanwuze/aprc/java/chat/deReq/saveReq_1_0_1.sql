-- ##Title 保存用户应聘需求
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 保存用户应聘需求
-- ##CallType[ExSql]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid，必填
-- ##input guid char[36] NOTNULL;应聘需求guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input sdPathAllName string[50] NOTNULL;采购供应路径全节点名称，必填
-- ##input reimg string[50] NOTNULL;用户简历图片，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input categoryName string[500] NOTNULL;品类名称，必填
-- ##input categoryAlias string[50] NULL;品类别名，必填
-- ##input categoryImg string[36] NOTNULL;品类图片，必填
-- ##input userId char[36] NOTNULL;用户id，必填
-- ##input userName string[50] NOTNULL;用户姓名，必填
-- ##input userPhone string[11] NOTNULL;用户手机号，必填
-- ##input sendType string[1] NOTNULL;投递类型，必填

insert into coz_chat_demand_request(guid,user_id,user_name,user_phone,reimg,sd_path_guid,sd_path_all_name,category_guid,category_name,category_img,category_alias,send_type,send_time,del_flag,create_by,create_time,update_by,update_time)
select
'{guid}' as guid
,'{userId}' as user_id
,'{userName}' as user_name
,'{userPhone}' as user_phone
,'{reimg}' as reimg
,'{sdPathGuid}' as sd_path_guid
,'{sdPathAllName}' as sd_path_all_name
,'{categoryGuid}' as category_guid
,'{categoryName}' as category_name
,'{categoryImg}' as category_img
,'{categoryAlias}' as category_alias
,'{sendType}' as send_type
,case when('{sendType}'='1') then now() else null end as send_time
,0 as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time