-- ##Title web-查询管制品类是否重复添加
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询管制品类是否重复添加
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称，非必填

-- ##output addedFlag int[>=0] 0;是否已经添加（0：未添加，1：已添加）

select
case when exists(select 1 from coz_category_buy_qualification where category_guid='{categoryGuid}' and del_flag=0) then '1' else '0' end as addedFlag