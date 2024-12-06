-- ##Title app-招聘方式管理-应聘人员查找-查询应聘人员-引入应聘方点击"我知道了"调用
-- ##Author lith
-- ##CreateTime 2023-09-14
-- ##Describe 
-- ##CallType[ProxyService]

-- ##input deRequestGuid char[36] NOTNULL;招聘需求guid(app调用生成guid获取)
-- ##input sdPathGuid char[36] NOTNULL;采购供应路径Guid
-- ##input categoryGuid char[36] NOTNULL;品类guid
-- ##input page int[>0] NOTNULL;页数
-- ##input size int[>0] NOTNULL;分页数量
-- ##input curUserId char[36] NOTNULL;当前登录用户id
-- ##input datas.fdCode char[6] NOTNULL;固化字段编码code
-- ##input datas.fdGuid string[36] NOTNULL;固化字段名称Guid
-- ##input datas.fdName char[50] NOTNULL;固化字段名称对应值guid
-- ##input datas.fdValueGuid char[36] NULL;固化字段名称对应值guid
-- ##input datas.fdValue string[200] NOTNULL;固化字段名称对应值

