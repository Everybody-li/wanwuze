-- ##Title 代理端-web后台-审批报价配置管理-xx供应路径-供应审批报价管理-品类审批报价管理-查询详情
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询
-- ##Describe t1有数据则返回，t2无数据时，出参型号报价方式为“非二维码”，t2有数据则取t2数据的值
-- ##Describe coz_category_supplier_am_model t1,coz_category_am_modelprice t2
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;业务guid：型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output bizGuid char[36] 业务guid;型号guid
-- ##output priceWay enum[0,1] 型号报价方式：1-非二维码，2-二维码;


select
t.guid as bizGuid
,(select price_way from coz_category_am_modelprice where biz_guid=t.guid and del_flag='0' order by id desc limit 1) as priceWay
from
coz_category_supplier_am_model t
where
t.guid='{bizGuid}' and t.del_flag='0'