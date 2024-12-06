-- ##Title web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2022-10-02
-- ##Describe 备注-后端：
-- ##Describe 1、根据入参bizCode计算操作哪张业务表
-- ##Describe 2、物理删除业务表生效数据
-- ##Describe 3、将业务表草稿状态数据改为生效数据
-- ##Describe 备注-前端：如有多个bizCode，一次性post多条数据过来
-- ##Describe 举例：[{"bizCode":"","bizGuid":"","curUserId":""},{"bizCode":"","bizGuid":"","curUserId":""},{"bizCode":"","bizGuid":"","curUserId":""}......]

-- ##Describe web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizCode string[6] NOTNULL;业务code，必填
-- ##input bizGuid string[36] NOTNULL;业务guid(支持多个)，必填


# 行政区域相关:将生效状态的节点删除
delete
from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}  t
where t.biz_guid='{bizGuid}' and  active_flag='1';

# 行政区域相关:将草稿状态的节点改成生效状态
update {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}  t
set t.active_flag = '1' where t.biz_guid='{bizGuid}' and active_flag='0';

# 固化字段内容:将生效状态的节点删除
delete
from coz_model_fixed_data_value_temp t
where t.biz_guid='{bizGuid}' and  active_flag='1';

# 固化字段内容:将草稿状态的节点改成生效状态
update coz_model_fixed_data_value_temp t
set t.active_flag = '1' where t.biz_guid='{bizGuid}' and active_flag='0';

