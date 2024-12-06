-- ##Title web机构-审批模式-切换合作项目-订单供应-成果交接-办理通知-办理-新增办理材料
-- ##Author 卢文彪
-- ##CreateTime 2023-07-18
-- ##Describe 新增
-- ##Describe 表名：coz_order_am_notice_file t1
-- ##CallType[ExSql]

-- ##input noticeGuid char[36] NOTNULL;办理通知guid
-- ##input imgName string[42] 办理图片名称;办理图片名称，例如：guid.png，目录：WEBSUORG/ORDER/AMNOTICE/{图片名称guid首字母}/
-- ##input rowIndex int[>0] 图片排序;图片排序
-- ##input curUserId char[36] NOTNULL;当前登录用户id


insert into coz_order_am_notice_file
(
guid
,notice_guid
,img_name
,row_index
,del_flag
,create_by
,create_time
)
select
uuid() as guid
,'{noticeGuid}' as noticeGuid
,'{imgName}' as imgName
,'{rowIndex}' as rowIndex
,'0' as del_flag
,'{curUserId}' as create_by
,now() as create_time
;