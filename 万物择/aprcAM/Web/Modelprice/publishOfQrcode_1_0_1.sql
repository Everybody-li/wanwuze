-- ##Title web后台-审批报价配置管理-品类审批报价管理-发布-型号报价方式为二维码的发布
-- ##Author 卢文彪
-- ##CreateTime 2023-08-03
-- ##Describe 前置条件：如果t1.型号报价方式不是二维码，则返回提示“当前报价方式不是二维码，出错了！”
-- ##Describe 逻辑描述：二维码方式的发布，新增日志表数据
-- ##CallType[QueryData]

-- ##input bizGuid char[36] NOTNULL;业务guid：型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output okFlag enum[0,1] 1;操作结果：0-发布失败，1-发布成功
-- ##output msg string[100] 操作提示语;操作提示语

set @publishFlag = (select case price_way 
				when '2' then '1'   
				else '0' end as pw
                                     from coz_category_am_modelprice
                                     where biz_guid = '{bizGuid}'
                                             and del_flag = '0')
;

set @existsFlag = (select case
                               when exists(select 1
                                           from coz_category_am_modelprice
                                           where biz_guid = '{bizGuid}'
                                             and del_flag = '0') then '1'
                               else '0' end)
;
set @publishHisFlag = (select case
                                  when exists(select 1
                                              from coz_category_am_modelprice_log
                                              where biz_guid = '{bizGuid}') then '1'
                                  else '0' end)
;

insert into coz_category_am_modelprice_log
( guid
, biz_guid
, cattype_guid
, category_guid
, price_way
, qrcode
, qrcode_url
, publish_flag
, publish_time
, publish_by
, del_flag
, create_by
, create_time)
select uuid()
     , '{bizGuid}'
     , cattype_guid
     , category_guid
     , price_way
     , qrcode
     , qrcode_url
     , '2'
     , now()
     , '{curUserId}'
     , '0'
     , '{curUserId}'
     , now()
from coz_category_am_modelprice
where biz_guid = '{bizGuid}'
  and @publishFlag = '1' and @existsFlag='1'
order by id desc
limit 1
;
update coz_category_am_modelprice
set publish_flag='2'
  , publish_time=now()
  , publish_by='{curUserId}'
where biz_guid = '{bizGuid}'
  and @publishFlag = '1' and @existsFlag='1'
;
insert into coz_category_am_modelprice_log
( guid
, biz_guid
, cattype_guid
, category_guid
, publish_flag
, publish_time
, publish_by
, del_flag
, create_by
, create_time)
select uuid()
     , '{bizGuid}'
     , t1.category_guid
     , t2.cattype_guid
     , '2'
     , now()
     , '{curUserId}'
     , '0'
     , '{curUserId}'
     , now()
from coz_category_supplier_am_model t
inner join
coz_category_supplier t1
on t.supplier_guid=t1.guid
inner join
coz_category_info t2
on t1.category_guid=t2.guid
where t.guid = '{bizGuid}'and @publishFlag = '1' and @existsFlag='0'
;
insert into coz_category_am_modelprice
(biz_guid
, cattype_guid
, category_guid
, publish_flag
, publish_time
, publish_by
, del_flag
, create_by
, create_time)
select '{bizGuid}'
     , t1.category_guid
     , t2.cattype_guid
     , '2'
     , now()
     , '{curUserId}'
     , '0'
     , '{curUserId}'
     , now()
from coz_category_supplier_am_model t
inner join
coz_category_supplier t1
on t.supplier_guid=t1.guid
inner join
coz_category_info t2
on t1.category_guid=t2.guid
where t.guid = '{bizGuid}'and @publishFlag = '1' and @existsFlag='0'
;
select case when (@publishFlag = '1') then '1' else '0' end as okFlag
     , case
           when (@publishFlag = '0') then '当前报价方式不是二维码，出错了！'
           when (@publishFlag = '1' and @publishHisFlag = '1') then '发布成功且覆盖原来版本，刷新后可使用'
           when (@publishFlag = '1') then '发布成功'
           else '当前报价方式不是二维码，出错了！' end                                  as msg
;










