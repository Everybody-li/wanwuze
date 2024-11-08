-- ##Title app-应聘-应聘方式管理-目标工作管理-查看工作信息-字段名称列表
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe
-- ##CallType[QueryData]

-- ##input recruitGuid char[36] NOTNULL;应聘信息guid，必填
-- ##input curUserId string[36] NOTNULL;登录用户id，必填

-- ##output fdName string[50] 字段名称;
-- ##output datas.value string[50] 字段值;
-- ##output datas.bizValue string[50] 业务字段值(后端、app端 ：当fd_code是行政区域类时，该值为区域code，其他时候为空);

select
name as fdName
,CONCAT('{ChildRows_aprc\\app\\chat\\EmployInsert\\getFieldValues_1_0_1:fdGuid=''',t.GUID,'''}') as datas
from
coz_model_fixed_data t
where exists(select 1 from coz_chat_employ_detail where employ_guid='{recruitGuid}' and fd_guid=t.guid and status='1') and del_flag='0'
;