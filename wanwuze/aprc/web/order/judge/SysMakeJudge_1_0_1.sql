-- ##Title web-非系统名义裁决意见批复
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-非系统名义裁决意见批复
-- ##CallType[QueryData]

-- ##input judgeGuid char[36] NOTNULL;裁决guid，必填
-- ##input orderGuid char[36] NOTNULL;订单guid，必填
-- ##input feeNo1 string[50] NOTNULL;仲裁账单类型1编号，必填
-- ##input feeNo2 string[50] NOTNULL;仲裁账单类型2编号，必填
-- ##input reason string[50] NOTNULL;裁决理由，必填
-- ##input result string[50] NOTNULL;裁决结果（1：需方违约，支持退款，2：供方违约，支持退款，3：交易正常，维持交易），必填
-- ##input thirdReports string[600] NULL;第三方报告图片，多个逗号分隔，非必填
-- ##input disobeyFee int[>=0] NULL;违约费违约费用，必填，没有就是0
-- ##input disobeyFeeRemark string[50] NULL;违约费用说明，非必填
-- ##input obeyFee int[>=0] NULL;赔偿金，必填，没有就是0
-- ##input obeyFeeRemark string[50] NULL;赔偿金说明，非必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

set @disobeyUserId=(select case when('{result}'='1') then demand_user_id when('{result}'='2') then supply_user_id else '0' end from coz_order where guid='{orderGuid}')
;
set @obeyUserId=(select case when('{result}'='1') then supply_user_id when('{result}'='2') then demand_user_id else '0' end from coz_order where guid='{orderGuid}')
;
set @disobeyObject=(select case when('{result}'='1') then '1' when('{result}'='2') then '2' else '0' end from coz_order where guid='{orderGuid}')
;
set @judgefeeguid1=uuid()
;
set @judgefeeguid2=uuid()
;
update coz_order_judge
set reason='{reason}'
,result='{result}'
,third_reports='{thirdReports}'
,disobey_fee='{disobeyFee}'
,disobey_fee_remark='{disobeyFeeRemark}'
,obey_fee='{obeyFee}'
,obey_fee_remark='{obeyFeeRemark}'
,disobey_user_id=@disobeyUserId
,obey_user_id=@obeyUserId
,disobey_object=@disobeyObject
,result_time=now()
,update_by='{curUserId}'
,update_time=now()
where 
guid='{judgeGuid}'
;
insert into coz_order_judge_fee(guid,judge_guid,fee_no,fee_type,fee,del_flag,create_by,create_time,update_by,update_time)
select
@judgefeeguid1
,'{judgeGuid}'
,'{feeNo1}'
,1
,{disobeyFee}
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
;
insert into coz_order_judge_fee(guid,judge_guid,fee_no,fee_type,fee,del_flag,create_by,create_time,update_by,update_time)
select
@judgefeeguid2
,'{judgeGuid}'
,'{feeNo2}'
,2
,{obeyFee}
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()
;
insert into coz_order_operation_log(guid,order_guid,last_status,status,operate_object,remark,create_by,create_time)
select
uuid()
,'{orderGuid}'
,ifnull((select status from coz_order_operation_log where order_guid='{orderGuid}' order by create_time desc limit 1),'0')
,'3'
,'0'
,''
,'{curUserId}'
,now()
;
insert into coz_order_notice(guid,cat_tree_code,user_id,user_type,order_guid,type,biz_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,case when ('{result}'='1') then 'demand' else 'supply' end
,disobey_user_id
,case when ('{result}'='1') then '1' else '2' end
,order_guid
,2
,@judgefeeguid1
,0
,'-1'
,now()
,'{curUserId}'
,now()
from
coz_order_judge t
where guid='{judgeGuid}' and '{result}'<>'3'
;
insert into coz_order_notice(guid,cat_tree_code,user_id,user_type,order_guid,type,biz_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,case when ('{result}'='1') then 'demand' else 'supply' end
,obey_user_id
,case when ('{result}'='1') then '1' else '2' end
,order_guid
,3
,@judgefeeguid2
,0
,'-1'
,now()
,'{curUserId}'
,now()
from
coz_order_judge t
where guid='{judgeGuid}' and '{result}'<>'3'
;
insert into coz_order_notice(guid,cat_tree_code,user_id,user_type,order_guid,type,biz_guid,del_flag,create_by,create_time,update_by,update_time)
select
uuid()
,case when ('{result}'='1') then 'demand' else 'supply' end
,t1.demand_user_id
,case when ('{result}'='1') then '1' else '2' end
,t.order_guid
,3
,t.biz_guid
,0
,'-1'
,now()
,'-1'
,now()
from
coz_order_judge t
left join
coz_order t1
on t.order_guid=t1.guid
where t.guid='{judgeGuid}' and '{result}'<>'3'
;