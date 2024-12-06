-- ##Title app-新增反馈
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe app-新增反馈
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;用户id，必填
-- ##input feedbackContent string[200] NOTNULL;采购编号（后端模糊搜索），非必填
-- ##input categoryName string[500] NOTNULL;采购编号（后端模糊搜索），非必填
-- ##input orderNo string[20] NOTNULL;采购编号（后端模糊搜索），非必填
-- ##input imgs string[2000] NOTNULL;采购编号（后端模糊搜索），非必填
-- ##input contact string[500] NOTNULL;采购编号（后端模糊搜索），非必填
-- ##input phone string[20] NOTNULL;采购编号（后端模糊搜索），非必填
-- ##input nation string[20] NOTNULL;采购编号（后端模糊搜索），区号，必填

insert into coz_order_refund_feedback
(guid,cat_tree_code,user_id,user_type,category_name,order_no,contact_name,contact_phone,nation,content,imgs,reply_time,reply_content,reply_content_read_time,del_flag,create_by,create_time,update_by,update_time)
select
UUID()
,'demand'
,'{curUserId}'
,'1'
,'{categoryName}'
,'{orderNo}'
,'{contact}'
,'{phone}'
,'{nation}'
,'{feedbackContent}'
,'{imgs}'
,null
,''
,null
,'0'
,'{curUserId}'
,now()
,'{curUserId}'
,now()