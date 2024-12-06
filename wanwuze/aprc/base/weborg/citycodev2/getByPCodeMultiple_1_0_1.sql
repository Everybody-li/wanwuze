-- ##Title web-多选-获取行政区域层级列表_1_0_2
-- ##Author 卢文彪
-- ##CreateTime 2020-06-05
-- ##Describe 前端:固化字段内容多选且是行政区域相关、企业业务类型、行业国标的用此接口获取数据,相关code枚举: 'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024'
-- ##CallType[QueryData]

-- ##input bizCode char[6] NOTNULL;业务字段内容code(例如:'c00008'、'c00009'、'c00010'、'c00011'、'c00012'、'c00021'、'c00022'、'c00023'、'c00020'、'c00024')
-- ##input curUserId string[36] NOTNULL;登录用户id
-- ##input bizGuid char[36] NOTNULL;业务guid
-- ##input nodeParentCode string[30] NOTNULL;父节点code


# 根据入参bizCode计算当前请求的行政区域为几级
set @maxlevel = (select case
                            when ('{bizCode}' = 'c00008') then 0
                            when ('{bizCode}' = 'c00009') then 1
                            when ('{bizCode}' = 'c00010') then 2
                            when ('{bizCode}' = 'c00011' or '{bizCode}' = 'c00022' or '{bizCode}' = 'c00023') then 3
                            when ('{bizCode}' = 'c00012') then 4
                            when ('{bizCode}' = 'c00021') then 5
                            when ('{bizCode}' = 'c00020') then 4
                            when ('{bizCode}' = 'c00024') then 3
                            else 0 end);

select case
           when ((baseChildrenCount = bizChildrenCount and bizChildrenCount > 0))
               then '2' -- 勾选
           when ((baseChildrenCount > bizChildrenCount and bizChildrenCount > 0))
               then '1' -- 半选
           when (bizChildrenCount = 0)
               then '0' -- 未选
           else '0' -- 未选
    end as nodeSelectedFlag
     , t.nodeCode
     , t.nodeParentCode
     , t.nodeAllParentCode
     , t.nodePathName
     , t.nodeName
     , t.nodeHasSon
from (select case
                 when @maxlevel > level and end_nodes_count > 0
                     then '1' -- 需要请求的层级大于结果节点层级 且 结果节点的子孙节点数量大于0，则表示结果节点有儿子(草稿节点)
                 else '0' end                                                                                                 as nodeHasSon
           , IF((end_nodes_count = 0), 1, end_nodes_count)                                                                    as baseChildrenCount -- 结果节点在基础表的子孙节点数量(草稿节点)
           , ifnull((select sum(case when (end_nodes_count = 0) then 1 else end_nodes_count end)
                     from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}
                     where code in (select ncode
                         from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTempTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url}
                            where biz_guid = '{bizGuid}'
                          and active_flag = '0'
                          and (ncode = t.code
                           or all_parent_code like concat('%,'
                            , t.code
                            , ',%')))), 0) as bizChildrenCount  -- 结果节点在业务表的子孙节点数量(草稿节点)
           , code                                                                                                             as nodeCode
           , id
           , parent_code                                                                                                      as nodeParentCode
           , all_parent_code                                                                                                  as nodeAllParentCode
           , path_name                                                                                                        as nodePathName
           , name                                                                                                             as nodeName
      from {url:[http://127.0.0.1:8011/html?SqlCmdName=aprc\base\getCodeTable_1_0_1&bizCode={bizCode}&DBC=w_a]/url} t
      where t.parent_code = '{nodeParentCode}') t
order by id;
