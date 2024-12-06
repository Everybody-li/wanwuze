-- ##Title 根据末级场景获取末级场景祖辈列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 根据末级场景获取品类字节内容列表
-- ##CallType[QueryData]

-- ##input fixedDataValueGuid char[36] NOTNULL;字节内容guid，必填

select
ifnull((select CONCAT('0',ifnull(all_parent_id,''),id,',0') from coz_model_fixed_data_value where guid = '{parentGuid}'),'''''')