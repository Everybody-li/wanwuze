-- ##Title web-查询行政区域弹窗关闭后的行政区域数据列表_1_0_2
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 前端:固化字段内容多选且是行政区域相关、企业业务类型、行业国标的用此接口获取数据,相关code枚举: 'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024'
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024')
-- ##input bizGuid char[36] NOTNULL;业务guid
-- ##input curUserId string[36] NOTNULL;登录用户id
-- ##input size int[>=0] NOTNULL;每页多少行数据（默认20）
-- ##input page int[>=0] NOTNULL;第几页（默认1）



# 查询草稿状态节点数据
select
    t.code as nodeCode     
    ,t.path_name as nodePathName
from
    {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} t
        inner join
    {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} t1
    on t.code=t1.ncode and t1.active_flag='0'
where t1.biz_guid='{bizGuid}' and t1.active_flag='0'
order by t.id
Limit {compute:[({page}-1)*{size}]/compute},{size};