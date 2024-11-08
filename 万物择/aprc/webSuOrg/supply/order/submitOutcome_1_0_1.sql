-- ##Title app-供应-发布成果
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-供应-发布成果
-- ##CallType[ExSql]

-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input type string[10] NOTNULL;成果类型(1：普通图片，2：普通文档），必填
-- ##input name string[200] NOTNULL;上传的文件名称，必填
-- ##input content string[500] NOTNULL;内容url，必填
-- ##input curUserId string[36] NOTNULL;供方用户id，必填

insert into coz_order_outcome(guid,order_guid,type,name,content,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,'{orderGuid}'
,'{type}'
,'{name}'
,'{content}'
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()