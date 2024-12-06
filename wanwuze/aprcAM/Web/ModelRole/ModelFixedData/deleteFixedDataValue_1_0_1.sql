-- ##Title web后台-型号专员操作管理-固化内容信息管理-固化内容库管理-编辑库内容-删除
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2019-07-08
-- ##Describe 删除:子孙一并删
-- ##CallType[ExSql]

-- ##input fixedDataValueGuid char[36] NOTNULL;字节内容guid，必填
-- ##input curUserId string[36] NOTNULL;当前登录用户id
-- ##input parentGuid string[36] NULL;上一段字节内容guid

update coz_model_fixed_data_value
set end_nodes_count=end_nodes_count-1
,update_by='{curUserId}'
,update_time=now()
where 
id in({url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\ModelRole\ModelFixedData\allParentId1&DBC=w_a&parentGuid={parentGuid}&OnlyTagReturn=true]/url})
;
update coz_model_fixed_data_value
set del_flag='2'
,update_by='{curUserId}'
,update_time=now()
where 
guid='{fixedDataValueGuid}' or all_parent_id like '{url:[http://127.0.0.1:8011/html?SqlCmdName=aprcAM\Web\ModelRole\ModelFixedData\allParentId&DBC=w_a&guid={fixedDataValueGuid}&OnlyTagReturn=true]/url}'
;