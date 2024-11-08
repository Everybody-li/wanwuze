-- ##Title java-审批模式-渠道需求提交-渠道需求内容逐条删除
-- ##Author 卢文彪
-- ##CreateTime 2023-09-11
-- ##Describe 新增t1,t2
-- ##Describe 根据入参guid删除
-- ##Describe 表名： coz_aprom_pre_demand_request_plate t1
-- ##CallType[ExSql]

-- ##input guid string[10240] NOTNULL;渠道需求guid


update coz_aprom_pre_demand_request_plate
set del_flag='2'
 ,update_time=now()
where guid in ({guid})
;