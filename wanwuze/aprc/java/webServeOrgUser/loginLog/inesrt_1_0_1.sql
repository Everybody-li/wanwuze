-- ##Title web-新增品类字节内容
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe web-新增品类字节内容
-- ##CallType[ExSql]

-- ##input seorgGuid string[36] NOTNULL;机构用户guid，必填
-- ##input phonenumber string[11] NOTNULL;登录ip，必填
-- ##input loginIp string[100] NOTNULL;本段字节标题的字节内容，必填

INSERT INTO coz_serve_org_login(guid,seorg_guid,phonenumber,login_ip,login_date,del_flag,create_by,create_time)
select 
UUID()
,'{seorgGuid}'
,'{phonenumber}'
,'{loginIp}'
,now()
,'0'
,'-1'
,now()
