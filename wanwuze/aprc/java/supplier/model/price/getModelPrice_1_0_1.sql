-- ##Title java-需求-型号-查询供方报价主信息
-- ##Author lith
-- ##CreateTime 2022-08-04
-- ##Describe 需求-型号-查询供方报价主信息
-- ##CallType[QueryData]

-- ##input modelGuid string[36] NOTNULL; 型号guid，必填
-- ##input curUserId string[36] NOTNULL;  登录用户id，必填

-- ##output modelGuid string[36] cf56ad39-8bd7-11ec-a488-00163e186ef5; 型号guid
-- ##output modelPriceGuid string[36] b4h3gqwh9-d5gk-17yj-6udr-0h1nweb6798; 型号价格guid
-- ##output bankName char[3] xxxx银行; 开户银行
-- ##output bankUserNo string[20] 20200210121005000001; 开户银行账号
-- ##output bankUserName string[20] xxxx; 开户账户名称
-- ##output bankAddr string[20] xxx路; 开户行地址
-- ##output supplyCompanyName string[50] xxx公司; 公司主体
-- ##output saleOnFlag char 销售开放标志：0-下架不销售，1：上架销; 门店地址
-- ##output saleOnTime string[50] 2022-02-25 12:12:12; 销售开放时间


select t.model_guid          as modelGuid,
t1.name as modelName,
       t.guid                as modelPriceGuid,
       t.bank_name           as bankName,
       t.bank_user_no        as bankUserNo,
       t.bank_user_name      as bankUserName,
       t.bank_addr           as bankAddr,
       t.supply_company_name as supplyCompanyName,
       t.sale_on_flag        as saleOnFlag,
       t.sale_on_time        as saleOnTime
from coz_category_supplier_model_price t
inner join
coz_category_supplier_model t1
on t.model_guid=t1.guid
where t.model_guid = '{modelGuid}' and t.del_flag='0'
