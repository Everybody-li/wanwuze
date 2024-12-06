-- ##Title app-查询招聘用人单位详情
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-查询招聘用人单位详情
-- ##CallType[QueryData]

-- ##input recruitGuid char[36] NOTNULL;招聘信息Guid，必填
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid，必填
-- ##input supplyUserId char[36] NOTNULL;供方用户id，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
t1.category_guid as categoryGuid
,t2.name as categoryName
,t2.img as categoryImg
,t3.user_name as nickName
,CONCAT('{ChildRows_aprc\\app\\chat\\crecruit\\getSupplyImgs_1_0_1:userId=''',t1.user_id,'''}') as `suImgs`
from
coz_chat_recruit t1
inner join
coz_category_info t2
on t1.category_guid=t2.guid
inner join
sys_app_user t3
on t1.user_id=t3.guid
where 
t1.user_id='{supplyUserId}' and t1.guid='{recruitGuid}' and t1.sd_path_guid='{sdPathGuid}' and t1.del_flag='0' and t2.del_flag='0' and t3.del_flag='0'