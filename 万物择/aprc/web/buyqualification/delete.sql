-- ##Title web-删除管制品类
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-删除管制品类
-- ##CallType[QueryData]

-- ##input qualificationGuid char[36] NOTNULL;品类采购资质guid，必填

update coz_category_buy_qualification
set del_flag=2
where guid='{qualificationGuid}'