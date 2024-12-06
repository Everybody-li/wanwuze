-- ##Title app-招聘信息页面字段-无值
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe app-招聘信息页面字段-无值
-- ##CallType[QueryData]

-- ##input recruitGuid char[36] NOTNULL;招聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

select
name as fdName
,CONCAT('{ChildRows_aprc\\app\\chat\\crecruit\\getFieldValues_1_0_1:fdGuid=''',t.GUID,'''}') as datas
from
coz_model_fixed_data t
where exists(select 1 from coz_chat_recruit_detail where recruit_guid='{recruitGuid}' and fd_guid=t.guid and status='1') and del_flag='0'
;
