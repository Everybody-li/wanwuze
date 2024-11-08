-- ##Title 系统发布-手动调整系统期限
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 系统发布-手动调整系统期限
-- ##CallType[ExSql]

update coz_order t
left join 
coz_category_deal_deadline t1
on t.category_guid=t1.category_guid
set 
accept_deadline=DATE_ADD(now(),interval t1.day HOUR)
,accept_cal_remark=concat(accept_cal_remark,concat(now(),'系统更改验收期限为',t1.day,'小时'))
where accept_time is null and supply_done_flag=1
;
