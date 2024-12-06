-- ##Title 获取需方当前绑定的对接专员信息
-- ##Author 卢文彪
-- ##CreateTime 2023-09-15
-- ##Describe 查询:t1.需方用户id=t2.需方用户id
-- ##Describe 表名：coz_server3_cate_dealstatus_statistic t1,create table coz_server3_sys_user_dj_bind t2
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;品类交易状态对应的业务guid:需求guid,供应报价guid,订单guid,订单取消guid,订单退货guid,订单仲裁guid

-- ##output sysUserGuid char[36] NOTNULL;需方对接专员用户id


select
t2.user_guid as sysUserGuid
from
coz_server3_cate_dealstatus_statistic t1
inner join
coz_server3_sys_user_dj_bind t2
on t1.demand_user_id=t2.binded_user_id
where
t1.biz_guid='{bizGuid}' and t1.del_flag='0' and t2.user_type='2'