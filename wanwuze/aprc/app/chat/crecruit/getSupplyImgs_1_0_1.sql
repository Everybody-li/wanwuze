-- ##Title app-查询招聘用人单位详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询招聘用人单位详情
-- ##CallType[QueryData]

select
t.user_id as userId
,t.img
from
coz_user_biz_img t
inner join
coz_cattype_sd_path t1
on t.supply_path_guid=t1.supply_path_guid
where 
t.user_id='{supplyUserId}' and t.del_flag='0' and t1.guid='{sdPathGuid}'