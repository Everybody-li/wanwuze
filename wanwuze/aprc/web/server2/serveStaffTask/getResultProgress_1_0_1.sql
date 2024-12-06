-- ##Title web-查询服务任务派发详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询服务任务派发详情
-- ##CallType[QueryData]

-- ##input serveTaskTobjectGuid char[36] NOTNULL;服务对象guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
concat(progressStr,'-',resultStr) as progressStr
,progressCreateTime
,resultRemark
from
(
select 
case when(t1.progress='1') then '对象联系阶段' when(t1.progress='2') then '材料收集阶段' when(t1.progress='3') then '信息应用阶段' else '' end as progressStr
,case when(t1.result='1') then '未完成(同意服务/收集完成)' when(t1.result='2') then '完成(拒绝服务)' when(t1.result='3') then '采购申请提交'when(t1.result='4') then '供应品类上架'when(t1.result='5') then '采购申请提交和供应品类上架' else '' end as resultStr
,left(t1.create_time,10) as progressCreateTime
,t1.result_remark as resultRemark
,t1.id
from 
coz_serve2_serve_task_tobject_result t1
where t1.serve_task_tobject_guid='{serveTaskTobjectGuid}' and t1.del_flag='0'
)t1
order by t1.id desc