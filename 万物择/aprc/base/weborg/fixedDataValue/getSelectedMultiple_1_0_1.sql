-- ##Title  web-多选-固化字段内容节点-查询字段内容弹窗关闭后的数据列表_1_0_2
-- ##Author 卢文彪
-- ##CreateTime 2023-11-06
-- ##Describe  前端: 当业务code是 c2开头时,例如 'c20001',则请求该接口获取字段内容数据
-- ##Describe  前端: web端供应机构,web后台运营经理,web后台型号专员处: 按单需求范围,型号需求范围,供应报价功能处使用
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c20001')
-- ##input bizGuid char[36] NOTNULL;业务guid
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>=0] NOTNULL;第几页（默认1）
-- ##input curUserId string[36] NOTNULL;登录用户id

-- ##output nodeCode string[36] 1;节点code
-- ##output nodePathName string[200] 1;节点全路径名称

# 查询草稿状态节点数据
select t.guid       as nodeCode
     , t.path_value as nodePathName
from coz_model_fixed_data_value t
         inner join coz_model_fixed_data_value_temp t1 on t.guid = t1.nguid and t1.active_flag = '0'
where t1.biz_guid = '{bizGuid}' and t.del_flag = '0'
  and t1.active_flag = '0'
order by t.id
Limit {compute:[({page}-1)*{size}]/compute},{size}



