-- ##Title web-多选-固化字段内容节点-在编辑需求范围/型号价格/按单报价用户点击保存时调用
-- 使用方:WebAPP
-- ##Author 卢文彪
-- ##CreateTime 2023-11-06
-- ##Describe  前端: 当业务code是 c2开头时,例如 'c20001',则请求该接口获取字段内容数据
-- ##Describe  前端: web端供应机构,web后台运营经理,web后台型号专员处: 按单需求范围,型号需求范围,供应报价功能处使用
-- ##CallType[ExSql]

-- ##input curUserId string[36] NOTNULL;登录用户id，必填
-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c20001')
-- ##input bizGuid string[4000] NOTNULL;业务guid(支持多个)，必填


# 将草稿状态的节点删除
delete
from coz_model_fixed_data_value_temp t
where t.biz_guid = '{bizGuid}'
  and active_flag = '0';


# 新增当前节点(生效状态的复制一份为草稿状态）
insert into coz_model_fixed_data_value_temp (guid,
                                             biz_guid,
                                             nparent_guid,
                                             nguid,
                                             all_parent_id,
                                             create_by,
                                             create_time)
select uuid(), '{bizGuid}', nparent_guid, nguid, all_parent_id, '{curUserId}', current_timestamp()
from coz_model_fixed_data_value_temp
where biz_guid = '{bizGuid}'
  and active_flag = '1';


