-- ##Title app-管理-审批模式下的品类-订单供应管理-成果交接管理-查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 查询,t1有数据就返回，t2或t3无数据不影响
-- ##Describe 过滤条件：查询当前采购供应路径下的需方自己的订单列表,且订单有成功支付的，不是子订单的，需方未验收通过的且供方未取消的
-- ##Describe 出参：成果接收按钮高亮标志逻辑：订单有成果就高亮，没有就置灰
-- ##Describe 出参：办理通知按钮高亮标志逻辑：订单有办理通知数据就高亮，没有就置灰
-- ##Describe 出参：通过验收按钮高亮标志逻辑：订单的供方有供应完成就高亮，没有就置灰
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
-- ##output hasOutcome enum[0,1] 成果发布按钮高亮标志：0-置灰，1-高亮;
-- ##output cancelBtnFlag enum[0,1] 取消订单按钮高亮标志：0-置灰，1-高亮;
-- ##output amNoticeBtnHighFlag enum[0,1] 办理通知按钮高亮标志：0-置灰，1-高亮;
-- ##output supplyDoneBtnHighFlag enum[0,1] 1;供应完成按钮高亮标志：0-置灰，1-高亮
-- ##output suReadFlag enum[0,1] 1;新订单供方阅读标志(0-未读，有红点，1-已读，无红点)
-- ##output orderNo string[20] 采购编号;
-- ##output categoryGuid char[36] 品类guid;
-- ##output categoryName string[500] 品类名称;
-- ##output categoryAlias string[20] 品类别名;
-- ##output orderTime string[16] 订单日期;订单日期
-- ##output categoryImg string[50] 品类图片;品类图片
-- ##output acceptBtnFlag enum[0,1] 1;通过验收按钮

select
t.guid as orderGuid
,t.request_guid as requestGuid
,t1.request_supply_guid as requestSupplyGuid
,t.request_price_guid as requestPriceGuid
,case when((select count(1) from coz_order_outcome where order_guid=t.guid and del_flag='0')>0) then '1' else '0' end as hasOutcome
,'1' as cancelBtnFlag
,case when (exists(select 1 from coz_order_am_notice where order_guid=t.guid)) then '1' else '0' end as amNoticeBtnHighFlag
,case when (t.supply_done_flag='1') then '1' else '0' end as supplyDoneBtnHighFlag
,t.supply_read_flag as suReadFlag
,t.order_no as orderNo
,t2.category_guid as categoryGuid
,t3.name as categoryName
,t3.alias as categoryAlias
,t3.img as categoryImg
,left(t1.create_time,16) as orderTime
,case when(t.supply_done_flag='1') then '1' else '0' end as acceptBtnFlag
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
t.sd_path_guid= '{sdPathGuid}' and t.demand_user_id= '{curUserId}' and t.del_flag='0' and t.pay_status= '2' and t.accept_status='0' and (not exists(select 1 from coz_order_cancel where order_guid=t.guid and del_flag='0' and cancel_object='2'))
order by t.id desc
Limit {compute:[({page}-1)*{size}]/compute},{size};
