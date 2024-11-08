-- ##Title web机构端-审批模式-切换合作项目-订单供应管理-成果交接管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 查询,t1有数据就返回，t2或t3无数据不影响
-- ##Describe 过滤条件：查询当前采购供应路径下的供方自己的订单列表,且订单有成功支付的，需方未验收通过的，供方未取消的
-- ##Describe 出参：成果发布按钮高亮标志逻辑：始终高亮
-- ##Describe 出参：取消订单按钮高亮标志逻辑：如果供方未供应完成就高亮,否则置灰
-- ##Describe 出参：办理通知按钮高亮标志逻辑：未办理通知,按钮高亮,办理后,置灰
-- ##Describe 出参：供应完成钮高亮标志逻辑：已办理通知且未供应完成,按钮高亮,否则置灰
-- ##Describe 表名： coz_order t1,coz_order_am_notice t2,coz_order_outcome t3,coz_order_cancel t4
-- ##CallType[QueryData]

-- ##input sdPathGuid char[36] NOTNULL;采购供应路径guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output orderGuid char[36] 订单guid;
-- ##output requestGuid char[36] 订单需求guid;
-- ##output requestSupplyGuid char[36] 订单需求供方guid;
-- ##output requestPriceGuid char[36] 订单需求供方报价guid;
-- ##output outcomeBtnHighFlag enum[0,1] 成果发布按钮高亮标志：0-置灰，1-高亮;
-- ##output cancelOrderBtnHighFlag enum[0,1] 取消订单按钮高亮标志：0-置灰，1-高亮;
-- ##output amNoticeBtnShowFlag enum[0,1] 办理通知按钮点击跳转逻辑：0-打开办理通知弹窗(按钮文字显示“办理通知”)、1-打开查看办理通知弹窗(按钮文字显示“查看办理通知”);
-- ##output amNoticeBtnHighFlag enum[0,1] 办理通知按钮高亮标志：0-置灰，1-高亮;
-- ##output supplyDoneBtnHighFlag enum[0,1] 供应完成按钮高亮标志：0-置灰，1-高亮;
-- ##output suReadFlag enum[0,1] 新订单供方阅读标志(0-未读，有红点，1-已读，无红点);
-- ##output orderNo string[20] 采购编号;
-- ##output categoryGuid char[36] 品类guid;
-- ##output categoryName string[500] 品类名称;
-- ##output categoryAlias string[20] 品类别名;
-- ##output orderTime string[16] 订单日期;订单日期
-- ##output categoryImg string[50] 品类图片;品类图片

select
t.guid as orderGuid
,t.request_guid as requestGuid
,t1.request_supply_guid as requestSupplyGuid
,t.request_price_guid as requestPriceGuid
,'1' as outcomeBtnHighFlag
,case when(t.supply_done_flag='1') then '0' else '1' end as cancelOrderBtnHighFlag
,case when (exists(select 1 from coz_order_am_notice where order_guid=t.guid)) then '1' else '0' end as amNoticeBtnShowFlag
,t.supply_read_flag as suReadFlag
,t.order_no as orderNo
,t2.category_guid as categoryGuid
,t3.name as categoryName
,t3.alias as categoryAlias
,t3.img as categoryImg
,left(t.create_time,16) as orderTime
,case when (exists(select 1 from coz_order_am_notice where order_guid=t.guid)) then '0' else '1' end as amNoticeBtnHighFlag
,case when (exists(select 1 from coz_order_am_notice where order_guid=t.guid) and t.supply_done_flag='0') then '1' else '0' end as supplyDoneBtnHighFlag
from
coz_order t
inner join
coz_demand_request_price t1
on t.request_price_guid=t1.guid
inner join
coz_demand_request t2
on t.request_guid=t2.guid
inner join
coz_category_info t3
on t2.category_guid=t3.guid
where 
t.sd_path_guid= '{sdPathGuid}' and t.supply_user_id= '{curUserId}' and t.del_flag='0' and t.pay_status= '2' and t.accept_status='0' and (not exists(select 1 from coz_order_cancel where order_guid=t.guid and del_flag='0' and cancel_object='2'))
order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};
