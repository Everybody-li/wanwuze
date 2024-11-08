-- ##Title 新增版本
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 新增版本
-- ##CallType[ExSql]

-- ##input weight int[>=0] NOTNULL;权重，必填
-- ##input platform string[50] NOTNULL;发布平台(1：安卓，2：IOS)，必填
-- ##input version string[50] NOTNULL;版本号,必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input size string[50] NOTNULL;大小,必填

insert into coz_app_version(guid,version,remark,platform,weight,size,status,publish_time,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,'{version}'
,'{remark}'
,'{platform}'
,{weight}
,'{size}'
,'2'
,null
,0
,'{curUserId}'
,now()
,'{curUserId}'
,now()
;
