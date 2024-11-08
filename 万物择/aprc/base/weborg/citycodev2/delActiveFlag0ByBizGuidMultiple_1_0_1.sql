-- ##Title web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2022-10-02
-- ##Describe web-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizCode string[6] NOTNULL;业务code(固化字段内容的code)，必填
-- ##input bizGuid string[4000] NOTNULL;业务guid(支持多个)，必填


# 将草稿状态的节点删除
delete
from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} t
where t.biz_guid ='{bizGuid}' and  active_flag='0';


# 新增当前节点(生效状态的复制一份为草稿状态）
insert into {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} (guid,
                                                                                                                                        biz_guid,
                                                                                                                                        nparent_code,
                                                                                                                                        ncode,
                                                                                                                                        all_parent_code,
                                                                                                                                        create_by,
                                                                                                                                        create_time)
select uuid(),'{bizGuid}',nparent_code,ncode,all_parent_code,'{curUserId}',current_timestamp()
from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} where biz_guid = '{bizGuid}' and active_flag = '1';


