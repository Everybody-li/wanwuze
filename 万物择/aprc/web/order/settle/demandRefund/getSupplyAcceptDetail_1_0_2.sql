-- ##Title web-查看退货验收情况详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看退货验收情况详情
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryImg string[200] 品类图片;品类图片
-- ##output categoryName string[20] 品类名称;品类名称
-- ##output categoryAlias string[20] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[20] 采购编号;采购编号
-- ##output orderTime string[10] 0000-00-00;订单日期（格式：0000-00-00）
-- ##output supplyAcceptTime string[10] 0000-00-00;退货提交日期（格式：0000-00-00）
-- ##output supplyAcceptWay int[>=0] 0;供方验收方式（0：未验收，1：手动验收，2：系统验收）
-- ##output supplyAccept int[>=0] 0;供方验收结果（0：未验收，1：验收通过，2：验收不通过）
-- ##output applyRuleGuid char[36] 适用规则guid;适用规则guid（退货验收规则）
-- ##output applyRuleName string[20] 适用规则名称;适用规则名称
-- ##output supplyNotAcceptReason string[200] 退货供方验收不通过理由;退货供方验收不通过理由
-- ##output supplyAccepProve string[600] 退货供方验收证明图片，多个逗号分隔;退货供方验收证明图片，多个逗号分隔

select
t2.img as categoryImg
,t2.name as categoryName
,t2.alias as categoryAlias
,t1.order_no as orderNo
,left(t1.create_time,10) as orderTime
,left(t.supply_accept_time,10) as supplyAcceptTime
,t.supply_accept_way as supplyAcceptWay
,t.supply_accept supplyAccept
,(select guid from coz_order_bussiness_rule where type = 22) as applyRuleGuid
,(select name from coz_order_bussiness_rule where type = 22) as applyRuleName
,t.supply_not_accept_reason as supplyNotAcceptReason
,case when(t1.need_deliver_flag='1') then t.supply_accept_prove else '系统自动办理完成' end as supplyAccepProve
,case when(t1.need_deliver_flag='1') then '1' else '2' end as refundHandleFlag
from
coz_order_refund t
left join
coz_order t1
on t.order_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
where 
t.order_guid='{orderGuid}' and t.del_flag='0'
union all
select
t2.img as categoryImg
,t2.name as categoryName
,t2.alias as categoryAlias
,t1.order_no as orderNo
,left(t1.create_time,10) as orderTime
,left(t.supply_done_time,10) as supplyAcceptTime
,t.supply_done_way as supplyAcceptWay
,'1' supplyAccept
,(select guid from coz_order_bussiness_rule where type = 22) as applyRuleGuid
,(select name from coz_order_bussiness_rule where type = 22) as applyRuleName
,'' as supplyNotAcceptReason
,'系统自动办理完成' as supplyAccepProve
,'2' refundHandleFlag
from
coz_order_cancel t
left join
coz_order t1
on t.order_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
where 
t.order_guid='{orderGuid}' and t.del_flag='0'