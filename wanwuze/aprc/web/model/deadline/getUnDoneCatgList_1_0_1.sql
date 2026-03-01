-- ##Title web-查询验收期限品类未设置列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe web-查询验收期限品类未设置列表
-- ##CallType[QueryData]

-- ##output categoryName string[500] NULL;品类名称(查询所有则传空)
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20），必填
-- ##input page int[>=0] NOTNULL;第几页（默认1），必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填


select
    t.guid         as categoryGuid
  , t.name         as categoryName
  , t.cattype_name as cattypeName
from
    coz_category_info              t
    inner join
        coz_category_deal_deadline t1
            on t.guid = t1.category_guid
where
      t1.day = 0
    {dynamic:categoryName[ and t.name like '%{categoryName}%' ]/dynamic}
  and t.del_flag = '0'
  and t1.del_flag = '0'
order by t.create_time desc
Limit {compute:[({page}-1)*{size}]/compute},{size}
;
select * from coz_category_deal_deadline
where cattype_guid='43cac285-f1ce-11ec-bace-0242ac120003' and category_guid = '43cac285-f1ce-11ec-bace-0242ac120003';

select
    *
from `apro-rec`.coz_category_info t1
left join coz_category_deal_deadline t2 on t1.guid = t2.category_guid
where t2.guid is null
and t1.cattype_guid='43cac285-f1ce-11ec-bace-0242ac120003';
# where guid  = '5b01bcbe-c100-4d4f-8f41-6dda0f562574'
# order by id desc
# limit 10;;

select * from coz_category_deal_deadline
# where category_guid =
# '5b01bcbe-c100-4d4f-8f41-6dda0f562574'
order by id desc
limit 10;

select * from coz_category_deal_rule
where category_guid =
'5b01bcbe-c100-4d4f-8f41-6dda0f562574';