-- ##Title web-查看退货证明
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查看退货证明
-- ##CallType[QueryData]

-- ##input refundGuid char[36] NOTNULL;退货guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output categoryImg string[200] 品类图片;品类图片
-- ##output categoryName string[20] 品类名称;品类名称
-- ##output categoryAlias string[20] 品类别名;品类别名，多个逗号隔开
-- ##output orderNo string[20] 采购编号;采购编号
-- ##output orderDate string[10] 0000-00-00;订单日期（格式：0000-00-00）
-- ##output refundTime string[10] 0000-00-00;退货提交日期（格式：0000-00-00）
-- ##output refundProveImg string[20] 退货证明图片;退货证明图片，多个逗号隔开
-- ##output supplyAcceptTime string[10] 0000-00-00;供方签收日期（格式：0000-00-00）
-- ##output supplyAcceptImg string[20] 供方签收证明图片;供方签收证明图片，多个逗号隔开
-- ##output applyRuleGuid char[36] 适用规则guid;适用规则guid（实物退货退款）
-- ##output applyRuleName string[20] 适用规则名称;适用规则名称

select
t2.img as categoryImg
,t2.name as categoryName
,t2.alias as categoryAlias
,t1.order_no as orderNo
,left(t1.create_time,10) as orderDate
,left(t.create_time,10) as refundTime
,t.prove_imgs as refundProveImg
,left(t.supply_accept_time,10) supplyAcceptTime
,case when (t.supply_accept_prove='0') then '' else t.supply_accept_prove end as supplyAcceptImg
,t.biz_rule_type23 as applyRuleGuid
,t3.name as applyRuleName
from
coz_order_refund t
left join
coz_order t1
on t.order_guid=t1.guid
left join
coz_category_info t2
on t1.category_guid=t2.guid
left join 
coz_order_bussiness_rule t3
on t.biz_rule_type23=t3.guid
where 
t.guid='{refundGuid}' and t.del_flag='0'