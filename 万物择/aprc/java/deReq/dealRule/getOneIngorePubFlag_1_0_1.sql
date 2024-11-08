-- ##Title 需求-查询品类的指派规则信息
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 需求-查询品类的指派规则信息
-- ##CallType[QueryData]

-- ##input categoryGuid char[36] NOTNULL;品类名称guid
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
    t.guid
     ,t.category_guid            					as categoryGuid
     ,t.price_mode               					as priceMode
     ,t.serve_fee_flag           					as serveFeeFlag
     ,IF(log.publish_time is null, '', left(log.publish_time,19))	as publishTime
     ,t.clone_falg              					as cloneFlag
    , IF(log.guid is null, 0, 1) 					as hisPublishFlag
from
    coz_category_deal_rule t left join coz_category_deal_rule_log log on t.guid = log.deal_rule_guid
where
        t.category_guid='{categoryGuid}'
order by t.id desc
limit 1
;