-- ##Title web-多选-行政区域节点打勾
-- ##Author lith
-- ##CreateTime 2023-06-15
-- ##Describe 前端:固化字段内容多选且是行政区域相关、企业业务类型、行业国标的用此接口获取数据,相关code枚举: 'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024'
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024')，必填
-- ##input bizGuid char[36] NOTNULL;业务guid
-- ##input nodeHasSon enum[0,1] NOTNULL;节点是否有儿子
-- ##input nodeCode string[20] NOTNULL;节点code
-- ##input nodeParentCode string[20] NOTNULL;父节点code
-- ##input nodeAllParentCode string[200] NOTNULL;父节点code
-- ##input curUserId string[36] NOTNULL;登录用户id


# 删除当前节点儿子节点(有儿子才删除，且删除草稿状态的)
delete
from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}
where {nodeHasSon} = 1
  and biz_guid = '{bizGuid}'
  and all_parent_code like concat('%,'
    , '{nodeCode}'
    , ',%')
  and active_flag='0';


# 新增当前节点(草稿状态）
insert into {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} (guid,
                                                                                                                                         biz_guid,
                                                                                                                                         nparent_code,
                                                                                                                                        ncode,
                                                                                                                                         all_parent_code,
                                                                                                                                         create_by,
                                                                                                                                         create_time)
select uuid(),
       '{bizGuid}',
       '{nodeParentCode}',
       '{nodeCode}',
       '{nodeAllParentCode}',
       '{curUserId}',
       current_timestamp()
where not exists(select 1 from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} where biz_guid = '{bizGuid}' and ncode = '{nodeCode}' and active_flag= '0');

call transAllChild2Parent_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}('{bizGuid}','{nodeParentCode}','{curUserId}');


# 查询当前节点父节点的选中状态(草稿状态)
# select case
#            when (bizChildrenCount = 0)
#                then '0' -- 未选
#            when ((baseChildrenCount > bizChildrenCount and bizChildrenCount > 0))
#                then '1' -- 半选
#            when ((baseChildrenCount = bizChildrenCount and bizChildrenCount > 0))
#                then '2' -- 选中
#            else '0'
#            end as nodeParentSelectedFlag
# from (
#          select case
#                     when @maxlevel > level and end_nodes_count > 0
#                         then '1' -- 需要请求的层级大于结果节点层级 且 结果节点的子孙节点数量大于0，则表示结果节点有儿子(草稿节点)
#                     else '0' end                              as nodeHasSon
#               , IF((end_nodes_count = 0), 1, end_nodes_count) as baseChildrenCount -- 结果节点在基础表的子孙节点数量(草稿节点)
#               , ifnull((select sum(case when (end_nodes_count = 0) then 1 else end_nodes_count end)
#                         from sys_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}
#                         where code in (select ncode
#                             from coz_biz_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}_temp
#                             where biz_guid = '{bizGuid}'
#                           and active_flag = '0'
#                           and (ncode = t.code
#                            or all_parent_code like concat('%,'
#                             , t.code
#                             , ',%')))), 0)                    as bizChildrenCount  -- 结果节点在业务表的子孙节点数量(草稿节点)
#          from sys_city_{url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} t
#          where t.parent_code = '0'
#      ) t
# ;