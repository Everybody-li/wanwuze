-- ##Title web机构-审批模式-切换合作项目-需求范围管理-需求范围设置-型号模式-编辑型号-有失效标红情况下，先调用该接口再调用编辑型号产品介绍接口
-- ##Author 卢文彪
-- ##CreateTime 2023-07-27
-- ##Describe 修改，将型号产品介绍板块内容失效的逻辑删除掉
-- ##Describe 表名：coz_category_supplier_am_model t1
-- ##CallType[ExSql]

-- ##input modelGuid char[36] NOTNULL;型号guid
-- ##input curUserId char[36] NOTNULL;当前登录用户id


# 将型号产品介绍板块内容失效的删除掉
update coz_category_supplier_am_model_price_plate
set del_flag= '2'
,update_by='{curUserId}'
,update_time=now()
where model_guid = '{modelGuid}' ;