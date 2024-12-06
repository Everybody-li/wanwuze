-- ##Title web机构端-审批模式-切换合作项目-成果交接管理-查看办理通知-查看办理通知图片文件
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##CallType[QueryData]

select
t.notice_guid as noticeGuid
,t.img_name as imgName
from
coz_order_am_notice_file t
where 
t.del_flag='0'
order by t.row_index