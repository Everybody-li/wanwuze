-- ##Title app-供应-新增用户业务图片
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-新增用户业务图片
-- ##CallType[ExSql]

-- ##input supplyPathGuid char[36] NOTNULL;供应路径guid，必填
-- ##input img string[50] NOTNULL;图片名称，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_user_biz_img(guid,user_id,supply_path_guid,img,remark,del_flag,create_by,create_time,update_by,update_time)
select
UUID() as guid
,'{curUserId}' as user_id
,'{supplyPathGuid}' as supply_path_guid
,'{img}' as img
,case when ('{supplyPathGuid}'='976c6ea8-f200-11ec-bace-0242ac120003') then '个人(家庭)简历图片' when ('{supplyPathGuid}'='9770dd7a-f200-11ec-bace-0242ac120003') then '企业简历图片' else '' end as remark
,0 as del_flag
,'{curUserId}' as create_by
,now() as create_time
,'{curUserId}' as update_by
,now()as update_time