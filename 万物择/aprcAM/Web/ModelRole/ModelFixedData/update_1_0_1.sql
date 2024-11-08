-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-编辑库内容
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 创建库名称--都是针对字段内容,增删改查表t1
-- ##Describe 修改:改名即可
-- ##Describe 表名：coz_model_fixed_data t1
-- ##CallType[ExSql]

-- ##input fixedDataGuid char[36] NOTNULL;固化内容信息库guid
-- ##input name string[20] NOTNULL;库名称
-- ##input curUserId string[36] NOTNULL;当前登录用户id


update coz_model_fixed_data
set name='{name}'
,update_by='{curUserId}'
,update_time=now()
where guid='{fixedDataGuid}'
;


