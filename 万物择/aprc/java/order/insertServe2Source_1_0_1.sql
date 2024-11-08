-- ##Title 更新订单相关服务模块数据
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 更新订单相关服务模块数据
-- ##CallType[ExSql]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input orderGuid string[36] NULL;订单guid，内部订单号，必填
-- ##input categoryGuid string[36] NULL;品类名称guid，内部订单号，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


insert into coz_order_serve2_source(guid,order_guid,serve_task_tobject_guid,object_guid,serve_staff_user_id,aprice_staff_user_id,create_time)
select
uuid()
,'{orderGuid}'
,t3.guid
,t3.object_guid
,t2.user_id
,ifnull((select user_id from coz_server2_sys_user_category where category_guid='{categoryGuid}' and del_flag='0' order by id desc limit 1),'')
,now()
from
coz_serve2_serve_task t2
inner join
coz_serve2_serve_task_tobject t3
on t2.guid=t3.serve_task_guid
where 
t2.sd_path_guid='{sdPathGuid}' and t2.del_flag='0' and t3.del_flag='0'
order by t3.id desc 
limit 1

