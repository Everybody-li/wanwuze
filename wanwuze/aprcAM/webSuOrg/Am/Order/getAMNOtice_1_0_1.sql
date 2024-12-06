-- ##Title web机构端-审批模式-切换合作项目-订单供应管理-成果交接管理-查看办理通知
-- ##Author 卢文彪
-- ##CreateTime 2023-08-08
-- ##Describe 查询，图片名称需按t2.排序字段顺序递增
-- ##Describe 表名：coz_order_am_notice t1,coz_order_am_notice_file t2
-- ##CallType[QueryData]

-- ##input orderGuid char[36] NOTNULL;订单guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id

-- ##output noticeDate string[10] 通知日期;通知日期
-- ##output doneTime string[15] 办理时间;办理时间
-- ##output place string[200] 办理地点;办理地点
-- ##output contactPerson string[20] 联系人;联系人
-- ##output contactPhone string[18] 联系电话;联系电话,后端拼接'(+86)'
-- ##output files.imgName string[100] 图片名称;图片名称，后端拼接相对路径


select
'' as noticeDate
,time as doneTime
,t.place
,t.contact_person as contactPerson
,t.contact_phone as contactPhone
,CONCAT('{ChildRows_aprcAM\\webSuOrg\\Am\\Order\\getAMNOticeFiles_1_0_1:noticeGuid=''',t.guid,'''}') as `files`
from
coz_order_am_notice t
where 
t.del_flag='0' and t.order_guid='{orderGuid}'
