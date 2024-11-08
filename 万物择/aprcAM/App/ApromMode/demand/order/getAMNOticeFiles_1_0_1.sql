-- ##Title app-管理-审批模式下的品类-成果交接管理-查看办理通知-查看办理通知图片文件
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 查询
-- ##CallType[QueryData]

select
t.notice_guid as noticeGuid
,concat('WEBSUORG/ORDER/AMNOTICE/',left(t.img_name,1),'/',t.img_name) as imgName
from
coz_order_am_notice_file t
where 
t.del_flag='0'
order by t.row_index