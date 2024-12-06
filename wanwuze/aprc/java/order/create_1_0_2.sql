-- ##Title 保存订单
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 保存订单
-- ##CallType[ExSql]

-- ##input guid char[36] NOTNULL;订单guid，必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径关联guid，必填
-- ##input parentGuid string[36] NULL;订单guid，非必填
-- ##input orderNo string[24] NOTNULL;订单编号，必填
-- ##input requestGuid char[36] NOTNULL;需求guid，必填
-- ##input requestPriceGuid char[36] NOTNULL;需求报价guid，必填
-- ##input categoryGuid char[36] NOTNULL;品类guid，必填
-- ##input demandUserId char[36] NOTNULL;需方用户id，必填
-- ##input supplyUserId char[36] NOTNULL;供方用户id，必填
-- ##input logisticsFee int[>=0] NOTNULL;物流费用，必填
-- ##input logisticsInsuranceFee int[>=0] NOTNULL;物流费用，必填
-- ##input demandServiceFee int[>=0] NOTNULL;需方服务费用，必填
-- ##input demandServiceFeeRemark string[100] NULL;需方服务费用说明，非必填
-- ##input supplyServiceFee int[>=0] NOTNULL;供方服务费用，必填
-- ##input supplyServiceFeeRemark string[100] NULL;供方服务费用说明，非必填
-- ##input taxFee int[>=0] NOTNULL;税费，必填
-- ##input discountFee int[>=0] NOTNULL;优惠金额，必填
-- ##input supplyFee int[>=0] NOTNULL;产品费用(供方报价)，必填
-- ##input invoiceTitle string[15] NULL;发票抬头，非必填
-- ##input invoiceType char[1] NULL;发票类型，非必填
-- ##input invoiceCompany string[35] NULL;开票单位，非必填
-- ##input invoiceTaxNumber string[50] NULL;纳税识别号，非必填
-- ##input invoiceAddrPhone string[100] NULL;地址、电话，非必填
-- ##input invoiceBankAccount string[100] NULL;开户行及账号，非必填
-- ##input needDeliverFlag string[1] NOTNULL;是否需要发货
-- ##input payType string[1] NOTNULL;支付类型（支付类型：0-未唤起支付或0元购,1-微信，2-支付宝），必填
-- ##input payStatus string[1] NOTNULL;支付状态：0-待支付，1-支付失败，2-支付成功，非必填
-- ##input payTime string[19] NULL;支付时间，非0元支付下，必填
-- ##input payNo string[50] NULL;支付流水号，非0元支付下，必填
-- ##input merchantNo string[50] NULL;商户订单号，来自微信/支付宝/0元支付
-- ##input userPayExtra string[200] NULL;用户支付信息json格式：{"buyer_id":"买家id","buer_logon_id":"买家登陆账号"}
-- ##input payFee int[>=0] NOTNULL;支付费用，必填
-- ##input totalFee int[>=0] NOTNULL;应付费用，必填
-- ##input curUserId string[36] NULL;登录用户id，必填
-- ##input deadlineDay int[>0] NOTNULL;品类验收期限，必填
-- ##input unitFee int[>=0] NOTNULL;单价,即服务定价基数,单位分

-- ##input quantity int[>=0] NOTNULL;购买数量

INSERT INTO coz_order
(guid, sd_path_guid, parent_guid, all_parent_id, order_no, request_guid, request_price_guid, category_guid,
 demand_user_id, supply_user_id, logistics_fee, logistics_insurance_fee, demand_service_fee, demand_service_fee_remark,
 supply_service_fee, supply_service_fee_remark, tax_fee, discount_fee, supply_fee, unit_fee, quantity, invoice_title,
 invoice_type,
 invoice_company, invoice_tax_number, invoice_addr_phone, invoice_bank_account, pay_fee, total_fee, pay_type,
 pay_status, pay_time, pay_no, merchant_no, user_pay_extra,
 need_deliver_flag, deadline_day, del_flag, create_by, create_time, update_by, update_time)
select '{guid}'                                          as guid
     , '{sdPathGuid}'                                    as sd_path_guid
     , '{parentGuid}'                                    as parent_guid
     , (select CONCAT(ifnull(CONCAT(all_parent_id, ','), ''), id)
        from coz_order
        where guid = '{parentGuid}')                     as all_parent_id
     , '{orderNo}'                                       as order_no
     , '{requestGuid}'                                   as request_guid
     , '{requestPriceGuid}'                              as request_price_guid
     , '{categoryGuid}'                                  as category_guid
     , '{demandUserId}'                                  as demand_user_id
     , '{supplyUserId}'                                  as supply_user_id
     , {logisticsFee}                                    as logistics_fee
     , {logisticsInsuranceFee}                           as logistics_insurance_fee
     , {demandServiceFee}                                as demand_service_fee
     , '{demandServiceFeeRemark}'                        as demand_service_fee_remark
     , {supplyServiceFee}                                as supply_service_fee
     , '{supplyServiceFeeRemark}'                        as supply_service_fee_remark
     , {taxFee}                                          as tax_fee
     , {discountFee}                                     as discount_fee
     , {supplyFee}                                       as supplyFee
     , {unitFee}                                         as unit_fee
     , {quantity}                                        as quantity
     , '{invoiceTitle}'                                  as invoice_title
     , '{invoiceType}'                                   as invoice_type
     , '{invoiceCompany}'                                as invoice_company
     , '{invoiceTaxNumber}'                              as invoice_tax_number
     , '{invoiceAddrPhone}'                              as invoice_addr_phone
     , '{invoiceBankAccount}'                            as invoice_bank_account
     , '{payFee}'                                        as payFee
     , '{totalFee}'                                      as total_fee
     , '{payType}'                                       as pay_type
     , '{payStatus}'                                     as pay_status
     , if('{payTime}' = '', null, '{payTime}')           as pay_time
     , '{payNo}'                                         as pay_no
     , '{merchantNo}'                                    as merchant_no
     , if('{userPayExtra}' = '', null, '{userPayExtra}') as user_pay_extra
     , '{needDeliverFlag}'                               as need_deliver_flag
     , '{deadlineDay}'                                   as deadline_day
     , '0'                                               as del_flag
     , '{curUserId}'                                     as create_by
     , now()                                             as create_time
     , '{curUserId}'                                     as update_by
     , now()                                             as update_time
;

# 0元支付时,处理交易状态 开始
set @demandSysUserGuid = '';
set @supplySysUserGuid = '';

# 查询需方用户的对接专员
select user_guid as sysUserGuid
into @demandSysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = '{demandUserId}'
  and user_type = '1'
  and '{payStatus}' = '2';


# 查询供方用户的对接专员
select user_guid as sysUserGuid
into @supplySysUserGuid
from coz_server3_sys_user_dj_bind
where binded_user_id = '{supplyUserId}'
  and user_type = '2'
  and '{payStatus}' = '2';

# 查询供方用户姓名和手机号
set @supplyUserName = '';
set @supplyUserPhone = '';
select name,phonenumber into @supplyUserName,@supplyUserPhone from coz_org_info
where user_id = '{supplyUserId}';

# 交易模式:0元支付时更新品类交易状态-采购需求支付,上一步是采购需求提交,一个需方对应多个供方,业务guid=需求guid
update coz_server3_cate_dealstatus_statistic
set biz_guid             = '{guid}'
  , update_time=now()
  , dstatus              = 214
  , demand_sys_user_guid = @demandSysUserGuid
  , supply_user_id = '{supplyUserId}'
  , supply_user_name = @supplyUserName
  , supply_user_phone = @supplyUserPhone
  , supply_sys_user_guid = @supplySysUserGuid
where biz_guid = '{requestGuid}'
  and dstatus = 211
  and '{payStatus}' = '2';

# 审批模式:0元支付时更新品类交易状态-采购需求支付,上一步是供方供应报价,一个需求对应一个供方,业务guid=报价guid
update coz_server3_cate_dealstatus_statistic
set biz_guid             = '{guid}'
  , update_time=now()
  , dstatus              = 317
  , demand_sys_user_guid = @demandSysUserGuid
  , supply_sys_user_guid = @supplySysUserGuid
where biz_guid = '{requestPriceGuid}'
  and dstatus = 316
  and '{payStatus}' = '2'
# 0元支付时,处理交易状态 结束
