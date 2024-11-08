-- ##Title web-系统名义裁决意见批复
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-系统名义裁决意见批复
-- ##CallType[QueryData]

-- ##input judgeGuid char[36] NOTNULL;裁决guid，必填
-- ##input reason string[50] NOTNULL;裁决理由，必填
-- ##input thirdReports string[600] NULL;第三方报告图片，多个逗号分隔，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,t.order_guid
,ifnull((select status from coz_order_operation_log where order_guid=t.order_guid order by create_time desc limit 1),'0')
,'3'
,'0'
,''
,'{curUserId}'
,now()
from
coz_order_judge t
where guid='{judgeGuid}' and result='0'
;
update coz_order_judge
set reason='{reason}'
,third_reports='{thirdReports}'
,result='4'
,result_time=now()
,update_by='{curUserId}'
,update_time=now()
where 
guid='{judgeGuid}' and result='0'
;
