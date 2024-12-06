-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-删除库名称
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 删除:关联的t2数据一起删
-- ##Describe 表名：coz_model_fixed_data t1  coz_model_fixed_data_value t2
-- ##CallType[ExSql]

-- ##input fixedDataGuid char[36] NOTNULL;固化内容信息库guid
-- ##input curUserId string[36] NOTNULL;当前登录用户id


update coz_model_fixed_data
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where guid='{fixedDataGuid}'
;


