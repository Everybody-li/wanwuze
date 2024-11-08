-- ##Title web-运营经理操作管理-品类交易管理-商品交易跟踪管理-沟通模式-招聘成果管理
-- ##Author 卢文彪
-- ##CreateTime 2023-09-13
-- ##Describe 备注：
-- ##Describe 招聘信息当前数量:根据品类名称guid统计t1的行数
-- ##Describe 招聘信息当前【上架】数量:根据品类名称guid统计t1.已上架的行数
-- ##Describe 点击【查询用人单位】累计数量:根据品类名称guid统计t2的行数
-- ##Describe 累计【投递简历】数量:t2关联t3,根据品类名称guid统计t2.投递类型是1的行数
-- ##Describe 点击【引入供方】累计数量:根据品类名称guid统计t2.投递类型是2的行数

-- ##Describe 表名：coz_chat_recruit t1,coz_chat_supply_request t2,coz_chat_supply_request_demand t3
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output curTotalEmployWorkCount int[>=0] 100;招聘信息当前数量
-- ##output curSalesonEmployWorkCount int[>=0] 10;招聘信息当前【上架】数量
-- ##output totalSearchSupplyCount int[>=0] 10;点击【查询用人单位】累计数量
-- ##output sendResumeCount int[>=0] 10;累计【投递简历】数量
-- ##output waitSupplyReq int[>=0] 10;点击【引入供方】累计数量

select 
(select count(1) from coz_chat_recruit where category_guid='{categoryGuid}' and del_flag='0') as curTotalEmployWorkCount
,(select count(1) from coz_chat_recruit where category_guid='{categoryGuid}' and del_flag='0' and sales_on='1') as curSalesonEmployWorkCount
,(select count(1) from coz_chat_supply_request where category_guid='{categoryGuid}' and del_flag='0') as totalSearchSupplyCount
,(select count(1) from coz_chat_supply_request a inner join coz_chat_supply_request_demand b on a.guid=b.de_request_guid where a.category_guid='{categoryGuid}' and a.del_flag='0' and b.del_flag='0' and a.send_type='1') as sendResumeCount
,(select count(1) from coz_chat_supply_request where category_guid='{categoryGuid}' and del_flag='0' and send_type='2') as waitSupplyReq