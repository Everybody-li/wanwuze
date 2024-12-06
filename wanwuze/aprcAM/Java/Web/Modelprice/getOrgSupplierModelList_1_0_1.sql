-- ##Title 审批模式-供方型号-根据品类guid查询列表
-- ##Author 卢文彪
-- ##CreateTime 2023-08-04
-- ##Describe 查询
-- ##Describe 出参”是否有型号内容“逻辑：t2有子数据t3，则是，否则为否
-- ##Describe coz_category_supplier t1,coz_category_supplier_am_model t2,coz_category_supplier_am_model_plate t3,coz_category_supplier_am_model_price_plate t4
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output modelName string[80] 供方机构名称;供方机构名称
-- ##output guid char[36] 供方品类guid;供方品类guid
-- ##output modelGuid char[36] 型号guid; 型号guid
-- ##output modelName string[50] 品类型号名;品类型号名
-- ##output modelId int[>=0] 品类型号id;品类型号id
-- ##output modelPriceWay enum[1,2,9] 1;型号报价方式：1-非二维码，2-二维码,9-异常值(未查到)
-- ##output hasModelPlateFlag enum[0,1] 1;是否有型号内容：0-否，1-是


select t1.guid          as guid
     , t.guid           as modelGuid
     , t.name           as modelName
     , t2.name          as orgName
     , t.id             as modelId
     , case
           when exists(select 1 from coz_category_supplier_am_model_plate where model_guid = t.guid and del_flag = '0')
               then '1'
           else '0' end as hasModelPlateFlag
,ifnull((select price_way from coz_category_am_modelprice_log where biz_guid=t.guid and del_flag='0' order by id desc limit 1),'9') as modelPriceWay
from coz_category_supplier_am_model t
         inner join coz_category_supplier t1 on t.supplier_guid = t1.guid
         inner join coz_org_info t2 on t1.user_id = t2.user_id
where t1.category_guid = '{categoryGuid}'
  and t.del_flag = '0'
  and t1.del_flag = '0'
  and exists(select 1
             from coz_category_supplier_am_model_price_plate
             where model_guid = t.guid
               and status = '1'
               and del_flag = '0')
Limit {compute:[({page}-1)*{size}]/compute},{size};